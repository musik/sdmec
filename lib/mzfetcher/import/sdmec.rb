# -*- encoding : utf-8 -*-
module Mzfetcher
  module Import
    class Sdmec
      HOME = 'http://www.sdmec.com'
      def import
        page = 1
        limit = 100
        while arr = fetch(page,limit) and arr.present?
          puts page #if Rails.env.test?
          arr.each do |r|
            t = Huati.where(:name=>r["name"]).first_or_create :slug=>r["cached_slug"]
            t.delay.import_sdmec   
          end
         page += 1
         # break
        end
      end
      def fetch(page,limit=100)
        req(HOME + "/api/topics.json?page=#{page}&limit=#{limit}")
      end
      def show(name)
        req(HOME + "/api/topics/#{CGI.escape(name.gsub(/\s+/,'-'))}.json")
      end
      def req(url)
        response = Typhoeus::Request.get(url)
        if response.success?
          JSON.parse response.body
        elsif response.timed_out?
          raise "got a time out"
        elsif response.code == 0
          # Could not get an http response, something's wrong.
          raise(response.curl_error_message)
        else
          # Received a non-successful http response.
          raise("HTTP request failed: " + response.code.to_s)
        end
      end
  
    end
  end
end
