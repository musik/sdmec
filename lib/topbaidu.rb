# -*- encoding : utf-8 -*-
class Topbaidu
   C1 = %w(top10 weekhotspot top_keyword shishuoxinci shijian)
   def self.run
     c=Core.new
     c.parse_sources
     # @channels = 
     c.run
   end
   def self.run_all
     c=Core.new
     c.parse_sources
     c.channels = c.channels - %w(top10 weekhotspot top_keyword shishuoxinci)
     # pp c.channels 
     c.run
   end
   def self.run_top
     c=Core.new
     c.channels = %w(top10 weekhotspot top_keyword shishuoxinci).reverse 
     c.run
   end
   class << self
     def fetch name
       Core.new.fetch name
     end
     def channels
       c=Core.new
        c.parse_sources
        c.channels
     end
   end
   
   class Core
     attr_accessor :channels
     def parse(url)
       pp url if Rails.env.test? 
       res = Typhoeus::Request.get(url)
       doc = Nokogiri::HTML(res.body.match(/<tbody>[\s\S]+<\/tbody>/)[0].encode("UTF-8","GBK"))
       # doc = doc.at_css('item description')#.content
       doc.css('tr').each do |tr|
         name = tr.css('td')[0].text
         next if name == '排名'
         priority = tr.css('td')[1].text.to_i
         e = Huati.where(:name=>name).first
         if e.present?
           e.update_attribute :priority,priority
         else
           e = Huati.create :name=>name,:priority=>priority
         end  
         # pp e if Rails.env.test?
       end
     end
     def parse_sources
       url = 'http://top.baidu.com/rss.php'
       res = Typhoeus::Request.get(url)
       # pp res.body
       @channels = res.body.scan(/rss_xml.php\?p=([a-z0-9_-]+)/).flatten.reverse
     end
     def fetch name
       parse "http://top.baidu.com/rss_xml.php?p=#{name}"
     end
     def run
       @channels.collect do |c|
         delay(:priority=>6).fetch c
         # break if Rails.env.test?
       end
     end
   end
end
