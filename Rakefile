%w[rubygems rake rake/clean fileutils].each { |f| require f }
require File.dirname(__FILE__) + '/lib/user_agent'

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].each{|f| load f }

# TODO - want other tests/tasks run by default? Add them to the list
task :default => [:spec]
