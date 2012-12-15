# -*- encoding : utf-8 -*-
module Mzfetcher
  module Pics
    class Youdao
      def initialize
        
      end
      def search(q)
        url = "http://image.youdao.com/search?q=#{CGI.escape(q)}"
        pp url if Rails.env.test?
        res=Typhoeus::Request.get(url)
        # doc = Nokogiri::HTML(res.body)
        res
      end
    end
  end  
end
