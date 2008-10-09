require File.dirname(__FILE__) + '/../lib/timetray'
%w( spec spec/mocks time ).each {|lib| require lib }

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
CreateTimeTrayDB.verbose = false
CreateTimeTrayDB.migrate :up

# use transactions
Project; # hit one of the AR classes
Spec::Runner.configure do |config|
  config.before(:each) do
    ActiveRecord::Base.active_connections.values.uniq.each do |conn|
      Thread.current['open_transactions'] ||= 0
      Thread.current['open_transactions'] += 1
      conn.begin_db_transaction
    end
  end
  config.after(:each) do
    ActiveRecord::Base.active_connections.values.uniq.each do |conn|                  
      conn.rollback_db_transaction
      Thread.current['open_transactions'] = 0
    end
  end
end
