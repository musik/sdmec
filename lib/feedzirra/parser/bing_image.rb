# -*- encoding : utf-8 -*-
module Feedzirra
  module Parser
    class BingImage
      include SAXMachine
      include FeedUtilities
      element :title
      element :subtitle, :as => :description
      element :link, :as => :url, :value => :href, :with => {:type => "text/html"}
      element :link, :as => :feed_url, :value => :href, :with => {:type => "application/atom+xml"}
      elements :link, :as => :links, :value => :href
      elements :entry, :as => :entries, :class => Feedzirra::Parser::BingImageEntry

      def self.able_to_parse?(xml) #:nodoc:
        /\<feed xmlns:base="https:\/\/api.datamarket.azure.com\/Data.ashx\/Bing\/Search\/v1\/Image"/ =~ xml
        # /\<feed[^\>]+xmlns=[\"|\'](http:\/\/www\.w3\.org\/2005\/Atom|http:\/\/purl\.org\/atom\/ns\#)[\"|\'][^\>]*\>/ =~ xml
      end

      def url
        @url || links.last
      end

      def feed_url
        @feed_url ||= links.first
      end
    end
  end
end
