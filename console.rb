#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/lib/timetray'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => DB_PATH
unless File.file?DB_PATH
  CreateTimeTrayDB.verbose = false
  CreateTimeTrayDB.migrate :up
end

require 'irb'

puts "Welcome to the TimeTray Console"
puts ""
puts "You should be able to directly access your data here"
puts "using objects including TimeTray, Project, Task, Log, etc"
puts ""
puts "enjoy!"
puts ""

IRB.start
