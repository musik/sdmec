class Site < ActiveRecord::Base
  belongs_to :user
  #has_and_belongs_to_many :items,:uniq=>true
  #has_and_belongs_to_many :shops,:uniq=>true,:class_name=>'Store'
  has_many :site_stores
  has_many :stores,:through=>:site_stores
  has_many :options,:class_name=>'SiteOption'

  #attr_accessible :description, :name, :slug, :slogan
  validates_presence_of :name,:slug
  validates_length_of :slug,:in=>4..16


  def add_item data
    item = Item.import_taobaoke_item data
    items << item
    item
  end
  def add_shop data
    shop = Store.import_from_taoke data
    shops << shop
    shop
  end
  def set_priority shop,priority=nil
    SiteStore.set_priority id,shop.id,priority
  end
  def set_option name,val,auto_load=nil,uniq=true
    uniq = true if auto_load
    if uniq
      data = {:val=>val,:autoload=>auto_load}
      e = options.where(:name=>name).first_or_initialize data
      e.new_record? ? e.save : e.update_attributes(data)
      e
    else
      options.create :name=>name,:val=>val
    end
  end
  def get_option name,uniq=true
    get_options
    return @cached_options[name] if @cached_options.has_key? name
    rs = options.where(:name=>name).pluck(:val).collect{|r| YAML.load r}
    uniq ? rs.first : rs
  end
  def real_val val
    YAML.load val
  end
  def get_options auto_load=true
    @cached_options ||= begin
      rs = {}
      options.where(auto_load ? {:autoload=>true} : {}).select('name,val').each do |r|
          rs[name] = YAML.load val
      end
      rs
    end
  end
end
