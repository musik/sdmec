# -*- encoding : utf-8 -*-
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
every "45 * * * *" do
  #rake "jobs:tbpage"
  rake "ts:in:delta"
end
#every "5 * * * *" do
  #rake "jobs:temai"
#end
#every "20 8,11,14,17 * * *" do
  #rake "jobs:topbaidu_all"
#end
#every "30 4 * * *" do
  #rake "jobs:pv_clear"
#end
# every "0 8,14 * * *" do
  # rake "jobs:ad"
# end
#every "5,35 * * * *" do
  #rake "jobs:topbaidu"
#end


# Learn more: http://github.com/javan/whenever
