class Project < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :tasks

  def get_task name
    task = tasks.find_or_create_by_name name
    tasks.reload
    task
  end
end
