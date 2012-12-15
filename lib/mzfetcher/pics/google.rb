# -*- encoding : utf-8 -*-
module Mzfetcher
  module Pics
    class Google
      KEY = 'AIzaSyDKL5U6Qy2j2uWgoSiZ5VIIIFIpb1S3qnA'
      def initialize
        
      end
      def search(q)
        url = "https://www.googleapis.com/customsearch/v1?q=#{CGI.escape(q)}&cx=013684218008945190437%3As9kympq27xc&searchType=image&key=#{KEY}"
        pp url if Rails.env.test?
        res=Typhoeus::Request.get(url)
        JSON.parse(res.body)
      end
    end
  end  
end
