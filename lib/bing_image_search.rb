# -*- encoding : utf-8 -*-
class BingImageSearch
  def initialize(user = '848107f4-30d9-4f97-bf56-6a42289f982e', password = 'nDQlmXx0Y3g/XnB1m4Cu+nwf8ELAnuv2zR6010ZKQ60=')
    @user = user
    @password = password
  end
  
  TOP = "&$top="
  BASE_URL = "https://api.datamarket.azure.com/Data.ashx/Bing/Search/v1/Image?Market=%27zh-CN%27&Query="
  
  def pp_search(q="xbox")
    images = get_feed(q, "2")
    images.each do |image|
      puts "ID: #{image.image_id}"
      puts "Title: #{image.title}"
      puts "MediaUrl: #{image.media_url}"
      puts "SourceUrl: #{image.source_url}"
      puts "DisplayUrl: #{image.display_url}"
      puts "Width: #{image.width}"
      puts "Height: #{image.height}"
      puts "FileSize: #{image.file_size}"
      puts "ContentType: #{image.content_type}"
      puts ""
      puts ""
    end
  
  end
  
  def get_feed(keyword = "ruby", top = "1")
    
    Feedzirra::Feed.add_feed_class Feedzirra::Parser::BingImage 
    feed = Feedzirra::Feed.fetch_and_parse(
                  BASE_URL + "%27" + CGI.escape(keyword) + "%27" + TOP + top.to_s, 
                  :http_authentication => [@user, @password])
    feed.entries
  end
end

