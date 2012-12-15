# -*- encoding : utf-8 -*-
class Link < ActiveRecord::Base
  attr_accessible :data, :name
  resourcify

  def self.cached_all
    Rails.cache.fetch "all_links" do
      rs = {}
      all.each do |r|
        rs[r.name] = r.data
      end
      rs
    end
  end
  class Alivv
    def self.fetch(wid='gMQati59D2Q=',type=3,code=1)
      url = "http://links.alivv.com/getcode.aspx?code=#{code}&wid=#{wid}&type=#{type}"
      res = Typhoeus::Request.get(url)
      if res.code == 200
        return CGI.unescape(res.body.encode("UTF-8",'GBK')).gsub(/<a[^>]+>友情链接平台<\/a>/,'').gsub(/<a[^>]+>博彩网站<\/a>/,'')

      end
      ""
    end
  end
end
