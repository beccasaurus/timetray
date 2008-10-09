require File.dirname(__FILE__) + '/spec_helper'

describe Task do

  before do
    @project = Project.create :name => 'w00t'
  end

  it 'should require a name and a project' do
    Task.new.should_not be_valid
    Task.new( :name => 'Doing Stuff' ).should_not be_valid
    Task.new( :project => @project ).should_not be_valid
    Task.new( :name => 'Doing Stuff', :project => @project ).should be_valid
  end

  it 'should have a unique name (per project)' do
    Task.create( :name => 'Doing Stuff', :project => @project ).should be_valid
    Task.create( :name => 'Doing Stuff', :project => @project ).should_not be_valid
    Task.create( :name => 'Doing Stuff 2', :project => @project ).should be_valid
  end

  it "should know whether it's currently 'active' based on when it's started / stopped" do
    task = Task.create :name => 'Doing Stuff', :project => @project
    task.should_not be_active
    task.logs.should be_empty

    Time.stub!(:now).and_return Time.parse('01/01/2000')
    task.start!
    task.should be_active
    task.logs.should_not be_empty
    task.logs.first.started_at.should == Time.parse('01/01/2000')

    Time.stub!(:now).and_return Time.parse('01/02/2000')
    task.stop!
    task.should_not be_active
    task.logs.length.should == 1
    task.logs.first.stopped_at.should == Time.parse('01/02/2000')

    task.total_time.should == 1.day

    Time.stub!(:now).and_return Time.parse('01/05/2000')
    task.start!
    Time.stub!(:now).and_return Time.parse('01/06/2000')
    task.stop!
    task.total_time.should == 2.days
    task.logs.count.should == 2
  end

end
