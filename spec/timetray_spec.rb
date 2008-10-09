require File.dirname(__FILE__) + '/spec_helper'

describe TimeTray do

  before do
    @project = Project.create :name => 'w00t'
    @another_project = Project.create :name => 'another w00t'
  end

  it 'should have a list of current tasks' do
    task1 = @project.tasks.create :name => 'Task 1'
    task2 = @another_project.tasks.create :name => 'Task 2'

    TimeTray.current_tasks.should be_empty
    task2.start!
    TimeTray.current_tasks.should_not be_empty
    TimeTray.current_tasks.should include(task2)
    task1.start!
    TimeTray.current_tasks.should include(task1)
    task1.stop!
    TimeTray.current_tasks.should_not include(task1)
    task2.stop!
    TimeTray.current_tasks.should be_empty
  end

end
