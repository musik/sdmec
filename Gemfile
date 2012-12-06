require 'rbconfig'
#gem "bundler", "~> 1.1.5"
HOST_OS = RbConfig::CONFIG['host_os']
source 'http://ruby.taobao.org'
gem 'rails', '3.2.5'
gem 'mysql2'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-ui-rails'
end
gem 'jquery-rails','2.1.3'
gem "haml", ">= 3.1.4"
gem "haml-rails", ">= 0.3.4", :group => :development
gem "rspec-rails", ">= 2.9.0.rc2", :group => [:development, :test]
gem "factory_girl_rails", ">= 3.2.0", :group => [:development, :test]
gem "email_spec", ">= 1.2.1", :group => :test
gem "guard", ">= 0.6.2", :group => :development
case HOST_OS
  when /darwin/i
    gem 'rb-fsevent', :group => :development
    gem 'growl', :group => :development
  when /linux/i
    gem 'libnotify', :group => :development
    gem 'rb-inotify', :group => :development
  when /mswin|windows/i
    gem 'rb-fchange', :group => :development
    gem 'win32console', :group => :development
    gem 'rb-notifu', :group => :development
end
gem "guard-bundler", ">= 0.1.3", :group => :development
gem "guard-rails", ">= 0.0.3", :group => :development
gem "guard-livereload", ">= 0.3.0", :group => :development
gem "guard-rspec", ">= 0.4.3", :group => :development
gem "devise", ">= 2.1.0.rc"
gem "cancan", ">= 1.6.7"
gem "rolify", ">= 3.1.0"
gem "bootstrap-sass","~> 2.1.0.0"
gem "simple_form"

#gem 'libv8'
gem "therubyracer", :group => :assets, :platform => :ruby

gem "stringex"


gem 'typhoeus'
gem 'thin'
gem 'unicorn'

gem 'rails-i18n'
gem 'devise-i18n'

gem 'kaminari','0.13.0'

gem 'nokogiri'

gem 'breadcrumbs'


gem 'thinking-sphinx', '2.0.13'
gem 'ts-datetime-delta', '1.0.3',:require => 'thinking_sphinx/deltas/datetime_delta'
#gem 'ts-delayed-delta', '1.1.3',:require => 'thinking_sphinx/deltas/delayed_delta'
gem "ts-resque-delta", "~> 1.2.2"
#gem "kyotocabinet"
#gem "kyotocabinet-ruby", "~> 1.27.1"
#gem 'kyototycoon'

gem "daemons"
#gem 'whenever', :require => false
gem 'delayed_job_active_record'
gem 'htmlentities'

gem 'awesome_nested_set'

# new topics
gem 'paper_trail', '~> 2'

gem 'feedzirra'

#gem 'oauth'
#gem 'oauth_china'
gem 'anemone'

gem 'redis-rails'
gem 'redis'
gem 'resque'
gem 'resque-ensure-connected'
gem 'resque-scheduler', :require => 'resque_scheduler'
gem 'resque-retry'
gem 'resque-cleaner'
gem 'resque-pool'
gem 'god'

#gem 'capistrano'

gem 'rails_admin'

gem 'acts_as_commentable_with_threading'
#gem "redis-model", "~> 0.1.3"
gem 'redis-objects', :require => 'redis/objects'
gem 'ohm'

gem 'acts-as-taggable-on'
