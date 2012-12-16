#encoding: utf-8
class Store < ActiveRecord::Base
  belongs_to :city
  attr_accessible :auction_count, :cid, :commission_rate, :created, :delivery_score, :item_score, :pic_path, :seller_credit, :seller_id, :nick, :service_score, :shop_id, :shop_title, :shop_type, :total_auction, :taoke_updated_at, :shop_updated_at,:city_id,:bulletin,:desc,:sid,:title,:modified,:click_url,:user_id,
    :buyer_credit, :hangye,:seller_rate,:extra_data,
    :user_updated_at, :comments_updated_at,:delta
  scope :updated,where('shop_updated_at is not null')
  scope :credit,order('seller_credit desc')
  scope :recent,order('id desc')
  scope :short,select([:title,:id,:city_id,:seller_credit])
  scope :incity,lambda{|city|
    if city.present?
      where(
        :city_id=> (city.parent_id>0 or city.zhixiashi?) ? city.id : City.where(:parent_id=>city.id).pluck(:id)
      )
    end
  }

  acts_as_commentable

  belongs_to :category,:foreign_key => 'cid',:primary_key => 'cid'

  #after_create :init_data

  define_index do
    indexes :title,:bulletin,:desc
    has :id
    has :city_id,:facets=>true
    has :seller_credit,:facets=>true
    has :shop_updated_at
    where "shop_updated_at is not null"
    #set_property :delta => false
    set_property :delta => ThinkingSphinx::Deltas::ResqueDelta
  end

  sphinx_scope :credit_desc do
    {:order=> "seller_credit DESC, @relevance DESC"}
  end
  sphinx_scope :srecent do
    {:order=> "shop_updated_at DESC, @relevance DESC"}
  end
  sphinx_scope :fullscan do
    {:match_mode=>:fullscan}
  end
  sphinx_scope :in_city do |city|
    {:with=>{
        :city_id=> (city.parent_id>0 or city.zhixiashi?) ? city.id : City.where(:parent_id=>city.id).pluck(:id)
    }}
  end
  def name
    title
  end
  def safe_title
    title.gsub(/成人用品/,'成用')
  end
  def mingan?
    @mingan ||= (title.match(/成人用品|性福|性用品|情趣/)) ? true : false
  end
  def init_data
    Resque.enqueue(ShopdataQueue,id,false)
  end
  def related limit=10
    self.class.search(title.gsub(/[ \^\@\$\&\(\)\[\]\-\/【】、（）☆]/,''),
        :without => {:id=>id},
        :include => [:city],
        :match_mode => :any,
        :sort_mode => :extended,
        :order => "@relevance DESC,seller_credit DESC",
        :per_page=>limit
      )
  end
  def import_shopdata
    rs = api.shop_get nick
    return if rs == false
    rs["shop"].delete("shop_score").each do |k,v|
      rs["shop"][k] = v
    end
    rs["shop"]["shop_updated_at"] = Time.now
    update_attributes rs["shop"]
  end
  def import_taokeshopdata
    rs = api.taobaoke_shops_convert nick
    if rs.present?
      rs = rs["taobaoke_shops"]["taobaoke_shop"].first
      else
      rs = {}
    end
    rs["delta"] = true
    rs["taoke_updated_at"] = Time.now
    update_attributes rs
  end
  def sync_update_taokedata
    Resque.enqueue(ShopxtaoQueue,id) if taoke_updated_at.nil? or (Time.now - taoke_updated_at)/86400 > 1
  end
  def import_shopuser
    url = "http://member1.taobao.com/member/userProfile.jhtml?&userID=#{nick}"
    pp Typhoeus::Request.get(url) 
  end
  def delay_jobs_require_user_id
      #delay(:priority=>2).import_userdata 
      #delay(:priority=>2).import_comments 
  end
  def import_userdata
    tb = Taobao.new
    data = tb.fetch_user user_id
    if data.present?
      data[:user_updated_at]=Time.now
      update_attributes data
    end
  end
  def update_items
    return if user_id.nil?
    results = api.taobaoke_items_relate_get :seller_id=>user_id
    if results.has_key?("total_results") and results["total_results"] > 0
      Resque.redis.set cached_items_key,results["taobaoke_items"]["taobaoke_item"].to_json
    else
      Rails.logger.info "shop.update_items:notice:#{results.inspect}"
    end
  end
  def cached_items_key
    "shop:items:#{id}"
  end
  def cached_items
    @cached_items ||= 
      begin
        results = Resque.redis.get cached_items_key
        results.nil? ? nil : JSON.parse(results)
      end
  end
  def import_comments
    tb= Taobao.new
  end
  def update_user_id
    response = Typhoeus::Request.get shop_url,:timeout=>30000
    if response.success?
      uid = response.body.match(/userid=(\d+);/)[1] rescue (return false)
      self.update_attributes :user_id=>uid
      delay_jobs_require_user_id
    else
      false
    end
  end
  def url
    "/tracklink/#{id}"
  end
  def real_url
    click_url.present? ? click_url : shop_url
  end

  def shop_url
    "http://shop#{sid}.taobao.com"
  end
  def user_url
    "http://rate.taobao.com/user-rate-#{user_id}.htm"
  end
  def pic_url
    "http://logo.taobaocdn.com/shop-logo#{pic_path}"
  end
  def city_slug
    city ? city.slug : "www"
  end

    def api
      @api ||= TaobaoFu::Api.new
    end
  class << self
    def import_by_username_and_city uname,city
      e = where(:nick=>uname).first_or_initialize :city_id=>city.id,:delta=>:false
      if e.new_record?
        e.save
        e.init_data
      end
      e
    end
    def import_by_uname_and_cityname uname,cityname
      e = where(:nick=>uname).first_or_initialize
      if e.new_record?
        e.city = City.find_by_name cityname unless cityname.nil?
        e.save
        e.init_data
      end
      e
    end
    def import_from_taoke data
      data["title"]=data.delete("shop_title")
      e = where(:nick=>data.delete("seller_nick")).first_or_initialize data
      if e.new_record?
        e.save
        e.init_data
      else
        e.update_attributes data
      end
      e
    end
    def fix_seller_credits
      where("seller_credit > 0").find_each do |s|
        s.update_attribute :seller_credit,nil
        s.delay(:priority=>0).import_taokeshopdata
      end
    end
  end
  class TaokeShop
    @queue = "taoshop"
    def api
      @api ||= TaobaoFu::Api.new
    end
    def run
      api = TaobaoFu::Api.new
      cats = TaobaoFu.fetch :method=>'taobao.shopcats.list.get',:fields=>'cid,name'
      cats["shop_cats"]["shop_cat"].each do |c|
        Resque.enqueue(TaokeShop,c["cid"])
      end
    end
    def count_cats
      api = TaobaoFu::Api.new
      cats = TaobaoFu.fetch :method=>'taobao.shopcats.list.get',:fields=>'cid,name'
      data = []
      cats["shop_cats"]["shop_cat"].each do |c|
        results = api.taobaoke_shops_get c["cid"]
        data << ["#{c['cid']}|#{c['name']}",results["total_results"]]
      end
      data.sort{|a,b| a[1] <=> b[1]}
    end
    def fetch_by_cid cid,page=1,run_next=true,options={}
      return if page > 100
      options[:page_no] = page
      results = api.taobaoke_shops_get cid,options.to_options

      if results["total_results"] > 0
        shops = results["taobaoke_shops"]["taobaoke_shop"]
        shops.each do |s|
          Store.import_from_taoke s
        end
      end
      if page == 1 and run_next and results["total_results"] > 20000
        extend_options = options.has_key?(:start_credit) ? rate_options : credits_options
        extend_options.each do |opts|
          Resque.enqueue(TaokeShop,cid,1,run_next,options.merge(opts))
        end
        return
      end
      Resque.enqueue(TaokeShop,cid,page.succ,run_next,options) if run_next and results["total_results"].zero? or results["total_results"] > page * 40
    end
    def credits_options
      h = []
      %w(heart diamond crown).each do |str|
        for i in 1..5 
          h << {:start_credit => "#{i}#{str}",:end_credit=>"#{i}#{str}"}
        end
      end
      h << {:start_credit => "1goldencrown",:end_credit=>"5goldencrown"}
      h
    end
    def rate_options
      [
        {:start_commissionrate => 50,:end_commissionrate => 499},
        {:start_commissionrate => 500,:end_commissionrate => 500},
        {:start_commissionrate => 501,:end_commissionrate => 5000}
      ]
    end
    def self.perform cid,page=1,run_next=true,options={}
      keep_time 0.6 do
        Store::TaokeShop.new.fetch_by_cid cid,page,run_next,options
      end
    end
  end
  
  class Jie
    def run
      
    end
    def run_all_cities
      City.where("parent_id > 0 or zhixiashi = ?",true).all.each do |city|
        next if city.id == 1
        async_search city.id
      end
    end

    def search_by_city city_id,page=1,run_next=true
      city = City.find city_id
      url = "http://soudian.taobao.com/search.htm?loc=#{CGI.escape(city.name.encode("GBK"))}&page=#{page}"
      Rails.logger.debug url
      response = Typhoeus::Request.get url,:user_agent=>"another 360 spider"

      if response.success?
        doc = Nokogiri::HTML(response.body,nil,'gbk')
        i=0
        doc.css('.shop-shopkeeper').each do |p|
          uname = p.attr("title")
          Store.import_by_username_and_city uname,city
          i+=1
        end
        return unless run_next
        has_next = !doc.at_css('a.page-next').nil?
        async_search(city.id,page+1) if has_next
      else
        Rails.logger.debug response
      end
    end
    def async_search city_id,page=1
      Resque.enqueue(::JieQueue,city_id,page)
    end
  end
  class Taobao
    attr_accessor :has_next_page
    def initialize
      @has_next_page = true
    end
    def fetch_user str
        url = "http://rate.taobao.com/user-rate-#{str}.htm"
        Rails.logger.debug url
        response = Typhoeus::Request.get(url)
        if response.success?
          doc = Nokogiri::HTML(response.body)
          #content = res.body.encode("UTF-8","GBK")
          data = {} 
          body = doc.at_css('body').content
          mt = body.match(/卖家信用：(\d+)/)
          if mt.present?
            data[:seller_score] = mt[1].to_i
          end
          #p body
          data[:buyer_credit] = body.match(/买家信用：\s+(\d+)/)[1].to_i rescue nil
          return data
        end
        false
    end
    def fetch_comments str
      url = "http://rate.taobao.com/member_rate.htm?content=1&result=&from=rate&user_id=#{str}&identity=1&rater=3&direction=1"
      url = "http://rate.taobao.com/member_rate.htm?content=1&result=-1&from=rate&user_id=#{str}&identity=1&rater=3&direction=1&page=6"
      log url
      res = Typhoeus::Request.get(url)
      log JSON.parse(res.body.strip.encode("utf-8","GBK").match(/^\((.+)\)$/)[1])
    end
    def get_comments uid,page=1,options={}
      defaults = {
        content:1, #有内容 '',1
        result:nil,#好中差 '',-1,0,1
        from:'rate',
        user_id:uid,
        identity:1,
        rater:1, # 卖家 3 买家 1  //3 1 给出
        direction:0,# 1 给出 0 得到 //3 0 来自卖家 1 0 来自买家
        page:page}
      options = defaults.merge options
      url = "http://rate.taobao.com/member_rate.htm?#{options.to_query}"
      res = Typhoeus::Request.get(url)
      data =  JSON.parse(res.body.strip.encode("utf-8","GBK").match(/^\((.+)\)$/)[1])
      @has_next_page = data["maxPage"] > data["currentPageNum"]
      data["rateListDetail"]
    end
  end

end
