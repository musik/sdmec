# -*- encoding : utf-8 -*-
class PageView < ActiveRecord::Base
  #attr_accessible :viewable_type, :viewable_id, :user_id, :referer, :user_agent, :ip, :visitor_hash
  belongs_to :viewable, :polymorphic => true

  scope :today, where(['created_at > ?',Time.zone.now.beginning_of_day])
  scope :month_ago, where(['created_at < ?',1.month.ago])  

  def self.get_statistics_for(type)
    e = Rails.env == 'production' ? 1.hour : 1.second
    Rails.cache.fetch("page_views_statistics_#{type}", :expires_in => e) do
      class_name = type.to_s.classify
      connection.select_rows("SELECT count(*) as cnt, DATE(created_at) as date FROM page_views WHERE viewable_type=\"#{class_name}\" GROUP BY date")
    end
  end

  def self.get_top_for(type,indays=30,limit=30)
    class_name = type.to_s.classify
    klass = class_name.constantize
    e = Rails.env == 'production' ? 1.hour : 1.second
    # ids = Rails.cache.fetch("page_views_top_#{type}", :expires_in => e) do
      # connection.select_rows("SELECT viewable_id, count(*) as cnt FROM page_views 
        # WHERE viewable_type=\"#{class_name}\" AND created_at>\"#{(Date.today-7).to_s :db}\" 
        # GROUP BY viewable_id ORDER BY cnt DESC LIMIT #{limit}")
    ids = where(:viewable_type=>class_name).
      # where("created_at > \"#{(Date.today-indays).to_s :db}\"").
      select("viewable_id, count(*) as count_all").
      group(:viewable_id).order("count_all desc").limit(limit).all.collect{|r|
        [r.viewable_id,r.count_all]
        }
    # end
    # logger.info ids
    objects_map = {}
    klass.find(ids.map{|a| a[0]}).each do |o|
      objects_map[o.id] = o
    end
    ids.map {|a| [objects_map[a[0].to_i], a[1]]}.reject {|a| a[0].nil?}
  end
  def self.get_top(type)
    class_name = type.to_s.classify
    klass = class_name.constantize
    where(:viewable_type=>class_name).
      select("viewable_id, viewable_type,count(*) as count_all").
      group(:viewable_id).order("count_all desc").includes(:viewable)
  end
  def self.get_top_in(type,indays=30)
    class_name = type.to_s.classify
    klass = class_name.constantize
    where(:viewable_type=>class_name).
      select("viewable_id, viewable_type,count(*) as count_all").
      # where("created_at > \"#{(Date.today-indays).to_s :db}\"").
      group(:viewable_id).order("count_all desc").includes(:viewable)
  end
  def self.get_recent_for(type,limit=100)
    class_name = type.to_s.classify
    klass = class_name.constantize
    where(:viewable_type=>class_name).
    group(:viewable_id).
      # group(:viewable_id).
      order("id desc").includes(:viewable).limit(limit).all
    # klass.find(ids)
  end
  
end
