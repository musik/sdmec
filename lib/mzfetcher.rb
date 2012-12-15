# -*- encoding : utf-8 -*-
# require 'mzfetcher/core'
require 'mzfetcher/news/youdao'
require 'mzfetcher/news/bing'

require 'mzfetcher/pics/youdao'
require 'mzfetcher/pics/bing'


require 'mzfetcher/import/sdmec'


module Mzfetcher
  class << self
    def apply method
      arr = method.split("/")
      @type = arr[0].titleize
      @method = arr[1].titleize
    end
    def cache
      ActiveSupport::Cache.lookup_store(:file_store, 
            "#{Rails.root}/tmp/#{@type}/#{@method}")
    end
    def get method,q
       apply method
       cache.fetch q do
         times = 3
         begin
          eval "#{@type}::#{@method}.new.search '#{q}'"
         rescue Exception=>e
           times -= 1
           retry if times > 0
           raise 
         end 
       end
    end
    def read method,q
      apply method
      cache.read q
    end
    def write method,q,data
      apply method
      cache.write q,data
    end
  end
end
