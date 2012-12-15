# -*- encoding : utf-8 -*-
class Huati < ActiveRecord::Base
  attr_accessible :content, :name, :slug,:published,:acr,:acr2,:priority,:delta
  
  resourcify
  
  after_create :delay_init_data
  before_create :make_slug,:ensure_acrs
  before_save :set_delta_flag
  
  scope :published,where(:published=>true)
  scope :recent,order("id desc")
  
  
  def set_delta_flag
    if changes["published"].present? and changes["published"][1] === true
      self[:delta] = true
    end 
  end
  #define_index do
  #  indexes name
  #  where sanitize_sql(["published", true])
  #  has :id
  #  
  #  #set_property :delta => :delayed
  #end
  def related n=10
    self.class.search(name,
      :without => id.nil? ? nil : {:id=>id},
      :match_mode => :any,
      :sort_mode => :extended,
      :order => "@relevance DESC",
      :per_page => n)
  end
  def to_param
    slug
  end
  
  # def make_delay
    # init_data
  # end
  def delay_init_data
    # fetch("news/youdao")
    delay(:queue => 'news-youdao',:priority=>-1).fetch("news/youdao")
    delay(:queue => 'pics-bing',:priority=>-1).fetch("pics/bing")
  end
  def rdata key
    
  end
  def redis
    @redis ||= Redis::Namespace.new("huati:#{id}",:redis=>Resque.redis.redis)
  end
  def weibo
      @weibo ||= 
      begin
        val = redis.get :weibo
        val.nil? ? nil : JSON.parse(val)
      end
  end
  def weibo= val
    redis.set :weibo,val
  end
    
  def sync_update_weibo
    Resque::enqueue(Weibo,id)
  end
  class Weibo
    @queue = "weibo"
    def self.perform id
      h = Huati.find id
      return if h.weibo.present?
      h.weibo= youdao(h.name)
    end
    def self.youdao word
      url = sprintf("http://news.youdao.com/search?q=%s&doctype=json",CGI.escape(word))
      response = Typhoeus::Request.get(url,:user_agent=>'Soso')
      if response.success?
        response.body
      else
        raise response.inspect
      end
    end
  end

  def fetch(method)
    r = Mzfetcher.get(method,name)
    publish if r.present? and !published?
    r
  end
  
  def make_slug
    self[:name].strip!
    unless self[:slug].present?
      str = self[:name].gsub(/[\/ ]/,'-').gsub(/-+/,'-').gsub(/(^-)|(-$)/,'')
      self[:slug] = str
      i = 0
      while self.class.find_by_slug(self[:slug]).present?
        i+=1
        self[:slug] = [str,i].join('-') 
      end
    end
  end
  def ensure_acrs
    arr = self[:name].to_ascii.downcase.strip.gsub(/[^\w\d]/,'-').split('-')
    self[:acr] = arr[0][0,1]
    self[:acr2] = arr[1].present? ?  [self[:acr] + arr[1][0,1]].join : arr[0][0,2] 
    self
  end
  def import_sdmec
    return if published?
    rs = Mzfetcher::Import::Sdmec.new.show(slug)
    %w(news images).each do |str|
      if rs[str].present?
        Mzfetcher.write "#{str}/old",name,rs[str]
      end
    end
    publish
  end
  def publish
    update_attribute :published,true
    # published = true
    # save
  end
  class << self
    def find *args
      return find_by_slug(args[0]) if args.size == 1 and args[0].to_i.zero?
      super
    end
    def unpublished_count
      puts where(:published=>nil).count
    end
    def update_unpublished
      
      where(:published=>nil).pluck(:id).each do |id|
        find(id).delay_init_data
      end
    end
    def import_from_sdmec
      Mzfetcher::Import::Sdmec.new.import
    end
  end
end
