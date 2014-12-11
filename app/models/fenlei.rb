class Fenlei < ActiveRecord::Base
  #attr_accessible :depth, :lft, :name, :parent_id, :position, :posts_count, :rgt, :slug
  acts_as_nested_set
  resourcify
  has_many :posts
  
  before_create :make_slug
  def to_param
    slug
  end
  def make_slug
    unless self[:slug].present?
      str = self[:name].gsub(/\//,'-')
      self[:slug] = str
      i = 0
      while Fenlei.find_by_slug(self[:slug]).present?
        i+=1
        self[:slug] = [str,i].join('-') 
      end
    end
  end
  class << self
    def find *args
      return find_by_slug(args[0]) if args.size == 1 and args[0].to_i.zero?
      super
    end
  end
  
end
