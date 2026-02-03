env :PATH, ENV['PATH']
env :GEM_HOME, ENV['GEM_HOME']
set :output, "/myapp/log/cron.log"
set :environment, :development

every 1.minute do
  rake "notification:send_reminders"
end