$:.unshift File.dirname(__FILE__)
%w( rubygems simpletray activerecord fileutils ).each {|lib| require lib }
Dir[ File.dirname(__FILE__) + '/timetray/*.rb' ].each {|lib| require lib }

DB_PATH = File.expand_path '~/.timetray/db.sqlite3'
FileUtils.mkdir_p File.dirname( DB_PATH )
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => DB_PATH

class TimeTray
  
  def self.current_tasks
    projects.inject([]){|all, project| all + project.current_tasks }
  end

  def self.projects
    Project.all
  end

end
