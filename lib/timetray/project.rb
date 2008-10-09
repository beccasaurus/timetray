class Project < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :tasks

  def get_task name
    task = tasks.find_or_create_by_name name
    tasks.reload
    task
  end

  def current_tasks
    tasks.reload
    tasks.select &:active?
  end

  def duration
    tasks.inject(0) {|total,task| total += task.duration }
  end
  alias total_time duration

  def to_s
    name
  end
end
