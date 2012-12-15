# -*- encoding : utf-8 -*-
module Feedzirra
  module Parser
    class BingImageEntry
      include SAXMachine
      include FeedEntryUtilities
      
      # element :id, :as => :entry_id
      element :updated
      element :'d:ID', :as => :id
      element :'d:Title', :as => :title
      element :'d:MediaUrl', :as => :media_url
      element :'d:SourceUrl', :as => :source_url
      element :'d:DisplayUrl', :as => :display_url
      element :'d:Width', :as => :width
      element :'d:Height', :as => :height
      element :'d:FileSize', :as => :file_size
      element :'d:ContentType', :as => :content_type
      element :'d:Thumbnail', :as => :thumbnail,:class => Feedzirra::Parser::BingImageThumbnailEntry

      def url
        @url ||= links.first
      end
    end
  end
end
