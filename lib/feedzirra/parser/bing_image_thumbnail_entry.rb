# -*- encoding : utf-8 -*-
module Feedzirra
  module Parser
    class BingImageThumbnailEntry
      include SAXMachine
      include FeedUtilities
      element :"d:MediaUrl",:as=>:media_url
      element :'d:Width', :as => :width
      element :'d:Height', :as => :height
      element :'d:FileSize', :as => :file_size
      element :'d:ContentType', :as => :content_type

      def url
        @url ||= links.first
      end
    end
  end
end
