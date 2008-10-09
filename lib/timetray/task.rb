class Task < ActiveRecord::Base
  validates_presence_of :name, :project
  validates_uniqueness_of :name
  belongs_to :project
  has_many :logs

  def start!
    logs.create unless active?
  end
  def stop!
    current_log.stop! if current_log
  end
  def active?
    not logs.select {|l| l.active? }.empty?
  end

  def duration
    logs.inject(0) {|total,log| total += log.duration }
  end
  alias total_time duration

  def current_log
    logs.select {|l| l.active? }.first # grab first one that's active
  end

  def to_s
    name
  end
end
