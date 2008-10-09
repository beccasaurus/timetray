#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/lib/timetray'

# ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:' # memory for now, for testing
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => DB_PATH
unless File.file?DB_PATH
  CreateTimeTrayDB.verbose = false
  CreateTimeTrayDB.migrate :up
end

SimpleTray.icon_directory = File.join File.dirname(__FILE__), 'icons'
SimpleTray.app 'TODO' do
 
  TimeTray.current_tasks.each do |task|
    menu "#{task.name} (#{time_ago_in_words task.current_log.started_at})" do
      stop { task.stop! }
    end
  end
  item('No Current Tasks'){} if TimeTray.current_tasks.empty?
  ____

  TimeTray.projects.each do |project|
    menu project.name do
      for task in project.tasks

        menu "#{ task }#{ (task.logs.empty?) ? '' : " (#{task.logs.count})" }" do

          # re-set task, using the menu text ('task' doesn't make it into this context)
          task = project.tasks.find_by_name self.get_text.sub(/ \(\d+\)/,'')

          # stop or start this task
          item (task.active? ? 'Stop' : 'Start') do
            if task.active?
              task.stop!
            else
              task.start!
            end
          end

          # task log history
          unless task.logs.empty?
            ____
            task.logs.each do |log|
              if log.active?
                item("started #{time_ago_in_words(log.started_at)} ago"){}
              else
                item(relative_time_span([log.started_at, log.stopped_at])){}
              end
            end
          end

        end # task menu
      end   # project menu

      ____ unless project.tasks.empty?
      new_task { project.tasks.create :name => prompt("New Task Name") }
    end
  end

  ____ unless TimeTray.projects.empty?
  item 'New Project' do
    Project.create :name => prompt('New Project Name')
  end

  ____
  exit
end
