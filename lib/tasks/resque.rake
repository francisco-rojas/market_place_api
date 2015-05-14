require 'resque/tasks'
require 'resque/scheduler/tasks'

# QUEUE=* rake environment resque:work
# rake environment resque:scheduler
namespace :resque do
  task :setup do
    require 'resque'
    require 'resque-scheduler'
  end
end