require File.dirname(__FILE__) + '/spec_helper'

describe Project do

  it 'should require a name' do
    Project.new.should_not be_valid
    Project.new( :name => 'Foo' ).should be_valid
  end

  it 'should require a unique name' do
    Project.create( :name => 'w00t' ).should be_valid
    Project.create( :name => 'w00t' ).should_not be_valid
    Project.create( :name => 'w00t 2' ).should be_valid
  end

  it 'should have tasks' do
    project = Project.create :name => 'w00t'
    project.tasks.should be_empty
    task = project.tasks.create :name => 'Doing Something Neat'
    project.tasks.should_not be_empty
    project.tasks.should include(task)
  end

  it 'should be easy to get a new or existing task' do
    project = Project.create :name => 'w00t'
    project.tasks.should be_empty

    task = project.get_task('Some Task')
    project.tasks.should_not be_empty
    task.name.should == 'Some Task'
    task.project.should == project

    project.get_task('Some Task').should == task
  end

  it 'should increment count from 0 projects to 1 project on create' do
    lambda {
      Project.create :name => 'w00t'
    }.should change(Project, :count).from(0).to(1)
  end

  it 'should *still* increment count from 0 projects to 1 project on create' do
    lambda {
      Project.create :name => 'w00t'
    }.should change(Project, :count).from(0).to(1)
  end

  it 'should have a list of current tasks' do
    project = Project.create :name => 'w00t'
    task1 = project.tasks.create :name => 'Task 1'
    task2 = project.tasks.create :name => 'Task 2'
    task3 = project.tasks.create :name => 'Task 3'

    project.current_tasks.should be_empty
    task2.start!
    project.current_tasks.should_not be_empty
    project.current_tasks.should include(task2)
    task3.start!
    project.current_tasks.should include(task3)
    task3.stop!
    project.current_tasks.should_not include(task3)
    task2.stop!
    project.current_tasks.should be_empty
  end

end
