# -*- encoding : utf-8 -*-
class Cat < ActiveRecord::Base
  attr_accessible :name, :oid, :slug,:parent_id
  acts_as_nested_set
  # acts_as_url :name,  :url_attribute=>:slug,  :only_when_blank=>true
  # scope :leaves,where("rgt - lft = 1")
  resourcify
  
  before_create :make_slug
  
  def to_param
    slug
  end
  def url
    "http://top.taobao.com/level3.php?cat=#{oid}"
  end
  def make_slug
    unless self[:slug].present?
      str = self[:name].gsub(/\//,'-')
      self[:slug] = str
      i = 0
      while Cat.find_by_slug(self[:slug]).present?
        i+=1
        self[:slug] = [str,i].join('-') 
      end
    end
  end
  
  def import_keywords
    TaobaoTop.new.run_keywords self
  end 
   
  class << self
    def find *args
      return find_by_slug(args[0]) if args.size == 1 and args[0].to_i.zero?
      super
    end
    def init_db
      delete_all
      TaobaoTop.new.get_cats
    end
    def tree
      rs = {}
      all.each do |r|
        rs[r.parent_id] = [] if !rs.has_key? r.parent_id
        rs[r.parent_id] << r
      end
      rs
    end
    def nav
      select(%w(name slug)).all
    end
  end
end
