# -*- encoding : utf-8 -*-
raw_config = File.read("#{Rails.root}/config/app_config.yml")
APP_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys
%w(expires_in expires_in_city).each do |str|
  APP_CONFIG[str.to_sym] = eval(APP_CONFIG[str.to_sym]) 
end

require 'extras/stringex_ex'
require 'extras/taobao_fu'
require 'kts'
require 'page_visit_tracker'
#require 'c7words'
require 'topbaidu'

%w(news news_entry image image_entry image_thumbnail_entry).each do |str|
  require "feedzirra/parser/bing_#{str}"
end

require 'mzfetcher'


require 'bing_image_search'