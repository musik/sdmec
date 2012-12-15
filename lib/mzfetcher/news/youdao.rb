# -*- encoding : utf-8 -*-
module Mzfetcher
  module News
    class Youdao
      def initialize
        
      end
      def search(q)
        times = 3
        begin
          url = "http://news.youdao.com/search?q=#{CGI.escape(q)}&doctype=json"
          res=Typhoeus::Request.get(url)
          JSON.parse(res.body)
        rescue Exception=>e
          pp e if Rails.env.test?
          times -= 1
          retry if times > 0
          raise
        end
      end
    end
  end  
end
