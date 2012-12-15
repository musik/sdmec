# -*- encoding : utf-8 -*-
module Mzfetcher
  module News
    class Bing
      KEY = Rails.env.test? ? 'nDQlmXx0Y3g/XnB1m4Cu+nwf8ELAnuv2zR6010ZKQ60=' : '/ktZOErL1eJvGOOr1p9KqdsVRMUok1i7wOR3Pdq5eUM='
      def initialize
        
      end
      def search(q,n=10)
        BingSearch.new(nil,KEY).get_news q,n
      end
    end
  end  
end



