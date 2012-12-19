class SiteStore < ActiveRecord::Base
  self.table_name = 'sites_stores'
  belongs_to :site
  belongs_to :store
  attr_accessible :priority
  def self.set_priority site_id,store_id,priority
    where(:site_id=>site_id,:store_id=>store_id).limit(1).update_all :priority=>priority
  end
end
