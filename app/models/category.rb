# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base
  #attr_accessible :cid, :is_parent, :name, :parent_cid, :sort_order, :status,:children_fetched,:parent_id,:display,:slug,:nicename,:keywords,:priority
  scope :sorted,order("sort_order asc")
  scope :display_with_priority,where(:display=>true).order("priority desc")
  #default_scope where(:display=>true).order("priority desc")
  has_many :children_displayed,
      :class_name=>Category,:conditions=>{:display=>true},
      :foreign_key=>'parent_id'
      #:order=>"priority desc"
  acts_as_nested_set
  resourcify

  def items
    leaf? ? Item.where(:cid=>cid) : Item.where(:cid=>self_and_descendants.pluck(:cid))
  end
  def to_param
    slug || cid
  end
  def nick
    @nick ||= (nicename.blank? ? name : nicename)
  end

  def parent_name
    parent.present? ? parent.name : nil
  end
  def import_children
    r = Category.import_from_parent cid
    unless r == false
      update_attribute :children_fetched,true
      sleep 90
    end
  end
  def update_items city=nil
    Item.import_by_cid cid,city
  end
  def async_import_shops 
    Resque.enqueue(::CatshopQueue,id)
  end
  def import_shops
    api =  TaobaoFu::Api.new
    rs = api.taobaoke_shops_get(cid)
    return false if rs.nil?
    pp rs
    rs["taobao_shops"]["taobaoke_shop"].each do |r|

    end
  end
  class << self
    def find_by_smart i
      i.to_i.zero? ? find_by_slug(i) : find_by_cid(i)
    end
    def inhome
      roots.includes(:children).all
    end
    def rebuild_parent_id
      pluck(:id).each do |id|
        c = find(id)
         if c.parent_cid > 0
          c.parent_id = find_by_cid(c.parent_cid).id
          c.save
         end
      end
    end
    def update_all_items
      Category.leaves.pluck(:id).each do |id|
        find(id).delay.update_items
      end
    end
    def cached_roots
      Rails.cache.fetch "category_roots" do
        roots
      end
    end
    def import_topcats
      api =  TaobaoFu::Api.new
      api.topats_itemcats_get

    end
    def import_all
      delete_all
      Resque.redis.del "queue:catim"
      #import_from_parent(0)
      async_import 0,nil
    end
    def import_failed
      len = Resque.redis.llen "failed"
      results = Resque.redis.lrange "failed",0,len
      results.each do |r|
        r = JSON.parse r
        if r["payload"]["class"] == "CatimQueue"
          args = r["payload"]["args"]
          next if args[0] == 0
          async_import args[0],args[1]
        end
      end
      nil
    end
    def async_import parent_cid,parent_id
      Resque.enqueue(::CatimQueue,parent_cid,parent_id)
    end
  end
end
