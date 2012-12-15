# -*- encoding : utf-8 -*-
module Mzfetcher
  module Pics
    class Bing
      KEY = '/ktZOErL1eJvGOOr1p9KqdsVRMUok1i7wOR3Pdq5eUM='
      def initialize
        
      end
      def search(q,n=10)
        BingImageSearch.new(nil,KEY).get_feed q,n
      end
    end
  end  
end



