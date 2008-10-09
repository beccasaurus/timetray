module SimpleTray::Builder
  # dialog examples: 
  #  * http://wxruby.rubyforge.org/wiki/wiki.pl?Using_Dialogs_To_Talk_To_Users
  #  * http://wxruby.rubyforge.org/wiki/wiki.pl?Using_Dialogs_To_Talk_To_Users_II
  def prompt message = 'Enter value', default = ''
    dialog = Wx::TextEntryDialog.new nil, message, message, default
    dialog.show_modal
    dialog.value
  end
end
