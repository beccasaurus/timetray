#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/lib/timetray'

SimpleTray.icon_directory = File.join File.dirname(__FILE__), 'icons'
SimpleTray.app 'TODO' do
 
  click_me do
    name = prompt 'Enter Name'
    msgbox "Your name is #{name}"
  end
  ____
  exit
end
