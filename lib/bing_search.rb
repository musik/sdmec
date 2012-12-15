# -*- encoding : utf-8 -*-
# require 'feedzirra'

class BingSearch
  def initialize(user = '848107f4-30d9-4f97-bf56-6a42289f982e', password = 'nDQlmXx0Y3g/XnB1m4Cu+nwf8ELAnuv2zR6010ZKQ60=')
    @user = user
    @password = password
  end
  
  TOP = "&$top="
  BASE_URL = "https://api.datamarket.azure.com/Data.ashx/Bing/Search/v1/News?Market=%27zh-CN%27&Query="
  
  def get_news(keyword = "ruby", top = "1")
    times = 3
    begin
      Feedzirra::Feed.add_feed_class Feedzirra::Parser::BingNews 
      feed = Feedzirra::Feed.fetch_and_parse(
                    BASE_URL + "%27" + CGI.escape(keyword) + "%27" + TOP + top.to_s, 
                    :http_authentication => [@user, @password])
      feed.entries
    rescue Exception=>e
      Rails.logger.info e
      pp e if Rails.env.test?      
      times -= 1
      retry if times > 0
      raise
    end 
  end
end

