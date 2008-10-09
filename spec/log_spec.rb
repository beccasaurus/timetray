require File.dirname(__FILE__) + '/spec_helper'

describe Log do

  before do
    @project = Project.create :name => 'w00t'
    @task    = Task.create    :name => 'foo', :project => @project
  end

  it 'should require a Task' do
    Log.new.should_not be_valid
    Log.new( :task => @task ).should be_valid
  end

  it 'should have a task and a project' do
    Log.new( :task => @task ).task.should == @task
    Log.new( :task => @task ).project.should == @project
  end

  it 'should default started_at to the current time' do
    Time.stub!(:now).and_return Time.parse('01/01/2000')
    log = Log.new
    log.valid? # have to check valid? before started_at will be set
    log.started_at.should == Time.parse('01/01/2000')
  end

  it 'should be active it not stopped' do
    Time.stub!(:now).and_return Time.parse('01/02/2000')

    log = Log.new :started_at => Time.parse('01/01/2000')
    log.should be_active
    log.duration.should == 1.day # checks Time.now

    log.stopped_at = Time.parse('01/03/2000')
    log.should_not be_active
    log.duration.should == 2.days
  end

  it 'should not be valid if there are any other active? logs for the given task' do
    log = Log.create :task => @task
    log.should be_valid
    log.should be_active

    log2 = Log.new :task => @task
    log2.should_not be_valid

    log.stop!
    log.should_not be_active
    log2.should be_valid
  end

end
