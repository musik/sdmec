# -*- encoding : utf-8 -*-
class Tc < ActiveRecord::Base
  belongs_to :topic
  belongs_to :city
  class << self
    def top(city_id)
      PageView.where(:viewable_type=>'Tc').
        select("count(*) as count_all,tcs.topic_id").
        group(:viewable_id).order("count_all desc").
        joins("left join tcs on tcs.id = page_views.viewable_id").
        where(["tcs.city_id = ?",city_id])
    end
    def recent city_id
      PageView.where(:viewable_type=>'Tc').
        select("tcs.topic_id").
        order("page_views.id desc").
        joins("left join tcs on tcs.id = page_views.viewable_id").
        where(["tcs.city_id = ?",city_id])
    end
    def recent_topics city_id,limit=50
      topics_from_pvs(recent(city_id).limit(limit).all)
    end
    def top_topics(city_id,limit=50)
      topics_from_pvs(top(city_id).limit(limit).all)
    end
    def topics_from_pvs(pvs)
      ids = pvs.collect{|r| r.topic_id}.uniq
      rs = {}
      Topic.where(:id=>ids).all.each do |r|
        rs[r.id] = r
      end
      ids.collect{|id| rs[id]}
    end  
  end
end
