# -*- encoding : utf-8 -*-
module Feedzirra
  module Parser
    class BingNewsEntry
      include SAXMachine
      include FeedEntryUtilities
      
      # element :id, :as => :entry_id
      element :updated
      element :'d:ID', :as => :id
      element :'d:Title', :as => :title
      element :'d:Url', :as => :url
      element :'d:Source', :as => :source
      element :'d:Description', :as => :description
      element :'d:Date', :as => :date
      def url
        @url ||= links.first
      end
    end
  end
end
