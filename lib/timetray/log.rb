class Log < ActiveRecord::Base
  belongs_to :task
  validates_presence_of :task, :started_at
  before_validation :set_started_at, :check_for_other_active_logs_for_this_task

  def project
    task.project
  end

  def active?
    stopped_at.nil?
  end

  def stop!
    update_attribute(:stopped_at, Time.now) unless stopped_at?
  end

  def duration
    (stopped_at || Time.now) - started_at
  end

  protected

  def set_started_at
    self.started_at = Time.now unless started_at?
  end
  def check_for_other_active_logs_for_this_task
    errors.clear
    if task
      task.logs.reload
      if task and task.logs.count > 0
        task.logs.each do |log|
          if log.active? and log != self
            errors.add_to_base "There's already another active log for task: #{task}"
            return false
          end
        end
      end
    end
  end
end
