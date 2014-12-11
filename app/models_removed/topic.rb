# -*- encoding : utf-8 -*-
class Topic < ActiveRecord::Base
  #attr_accessible :name,:volume,:acr,:acr2,:items_updated_at,:public
  # acts_as_url :name,  :url_attribute=>:slug,  :only_when_blank=>true
  has_many :page_views, :as => :viewable, :dependent => :destroy
  resourcify
  
  scope :publics,where(:public=>true)
  scope :unfetched,joins("left join cts on cts.topic_id = id and cts.city_id is null").where("cts.topic_id is null")
  scope :fetched,joins("left join cts on cts.topic_id = id and cts.city_id  is null").where(["cts.fetched = ?",true])
  
  scope :fetched_in_city,lambda{|city| 
      publics.joins("left join cts on cts.topic_id = id and cts.city_id = #{city.id}").where(["cts.fetched = ?",true]) 
      }
  scope :unfetched_in_city,lambda{|city| 
      joins("left join cts on cts.topic_id = id and cts.city_id = #{city.id}").where("cts.topic_id is null") 
      }
  after_create :make_delay
  before_create :make_slug,:ensure_acrs
  has_many :cts
  before_save :set_delta_flag

  def set_delta_flag
    if changes["public"].present? and changes["public"][1] === true
      self[:delta] = true
    end 
  end  
  
  
  def to_param
    slug
  end
  def make_delay
    delay(:queue => 'api',:priority=>1).init_data
  end
  def make_slug
    self[:name].strip!
    unless self[:slug].present?
      str = self[:name].gsub(/[\/ ]/,'-').gsub(/-+/,'-').gsub(/(^-)|(-$)/,'')
      self[:slug] = str
      i = 0
      while Topic.find_by_slug(self[:slug]).present?
        i+=1
        self[:slug] = [str,i].join('-') 
      end
    end
  end

  #define_index do
  #  indexes name
  #  where sanitize_sql(["public", true])
  #  has :id
  #  
  #  #set_property :delta => :delayed
  #end
  
  # def load_items city=nil,page=1
    # city_id = city.nil? ? 0 : city.id 
    # e = Ct.where(:city_id=>city_id,:topic_id=>id).first
    # pp e
  # end
  def items options={}
    options = parse_options options
    ckey = cache_key options 
    logger.info ckey
    rs = Kts.get ckey
    # logger.info rs
    delay.update_items(ckey,options) if rs.nil? 
    if rs == "-1"
      delay(:run_at=>5.minutes.from_now).update_items(ckey,options) 
      rs = false
    end
    rs
  end
  def parse_options options={}
    if options[:city].present?
      city = options[:city]
      location_key = 'area'
      options[location_key] = city.name
      # options.delete :city 
    end
    options
  end
  def cache_key options={}
    str = id.nil? ? "name-#{name}" : id.to_s
    if options.present?
      options.delete :city
      str += options.to_s
    end
    "items-#{str}"
  end
  def init_data
    update_items(cache_key)
    update_attribute :public,true
  end
  def update_items ckey,options={}
      if options[:city].present?
        city = options[:city]
        options.delete :city
      end
      rs = TaobaoFu::Api.new.taoke_get_items_by_keyword(name,options)
      if rs != false and (options[:page_no].nil? or  options[:page_no].to_i == 1)
        Ct.where(:city_id=>(city.id rescue nil),:topic_id=>id).first_or_create(
            :fetched=>true,
            :fetched_at=>Time.now,
            :items_count => rs.present? ? rs["total_results"] : 0)
      end
      if rs != false
        Kts.write ckey do
          rs
        end
      end
      rs
  end
  
  def dached_items expires_in=7.day,options={}
    if options[:city].present?
      city = options[:city]
      # location_key = city.parent_id.zero? ? 'location.state' : 'location.city'
      location_key = 'area'
      options[location_key] = city.name
      options.delete :city 
    end
    cache_key = id.nil? ? "name-#{name}" : id.to_s
    cache_key += options.to_s if options.present?

    Kts.fetch "items-#{cache_key}",:expires_in => expires_in do
      rs = TaobaoFu::Api.new.taoke_get_items_by_keyword(name,options)
      if rs != false and id.present? and (options[:page_no].nil? or  options[:page_no].to_i == 1)
        Ct.where(:city_id=>(city.id rescue nil),:topic_id=>id).first_or_create(
            :fetched=>true,
            :fetched_at=>Time.now,
            :items_count => rs.present? ? rs["total_results"] : 0)
      end
      rs
    end
  end
  def cached_items expires_in=7.day,options={}
    if options[:city].present?
      city = options[:city]
      location_key = city.parent_id.zero? ? 'location.state' : 'location.city'
      options[location_key] = city.name
      options.delete :city 
    end
    cache_key = id.nil? ? "name-#{name}" : id
    Rails.cache.fetch "items-#{cache_key}-#{options}",:expires_in => expires_in do
      rs = TaobaoFu::Api.new.get_items(name,options)
      # update_attribute :items_updated_at,Time.now
      # if id.present? and city.present? and (options[:page_no].nil? or  options[:page_no].to_i == 1)
        # Ct.where(:city_id=>city.id,:topic_id=>id).first_or_create(:items_count => rs.present? ? rs["total_results"] : 0)
      # end
      rs
    end
  end
  def related n=10
    #ck = id.nil? ? "name-#{name}" : id
    Topic.search(name,
      :without => id.nil? ? nil : {:id=>id},
      :match_mode => :any,
      :sort_mode => :extended,
      :order => "@relevance DESC",
      :per_page => n)
  end
  def update_acrs
    data ={} 
    str = name.to_ascii.downcase.strip.gsub(/[^\w\d]/,'-')
    data[:acr] = str[0,1]
    data[:acr2] = str[0,2]
    update_attributes data
  end
  def ensure_acrs
    str = self[:name].to_ascii.downcase.strip.gsub(/[^\w\d]/,'-')
    self[:acr] = str[0,1]
    self[:acr2] = str[0,2]
    self
  end
  
  class << self
    def clean_percents
      puts Topic.where("slug like '%percent%'").delete_all
      puts Topic.where("slug like '%equals%'").delete_all
      puts Topic.where("slug like '%city-visit%'").delete_all
    end
    def init_public
      puts Topic.where("created_at < '2012-05-09'").count
      puts Topic.where("created_at < '2012-05-09'").update_all :public=>true 
    end
    def remove_unpublics
      puts Topic.where(:public=>nil).delete_all
    end
    def all_update_items
      @last = nil
      @fails = [0]
      
      @logger = ActiveSupport::BufferedLogger.new("#{Rails.root}/log/update_#{Rails.env}.log")
      @logger.info "start at #{Time.now}.\n"
      
      i=0
      
      while i+=1
        logger.info i
        rs = unfetched.where(["topics.id not in (?)",@fails]).limit(10).all 
        break unless rs.present?
        rs.each do |t|
          begin
            r,@last = keep_safe 3,@last do
              t.dached_items
            end
            @logger.info "Done #{Time.now} #{t.id}"
          rescue Exception=>e
            @logger.info "Error #{e.class} #{e.message} #{t.id} #{t.name}"
            @fails << t.id
            sleep 90
          end
        end
      end
    end
    def keep_safe i=3,last=nil,&block
      unless last.nil?
        t = Time.now - last
        sleep(i-t) if i > t
      end
      [yield,Time.now]
    end
  end
end
