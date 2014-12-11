class SiteOption < ActiveRecord::Base
  belongs_to :site
  #attr_accessible :autoload, :name, :val
end
