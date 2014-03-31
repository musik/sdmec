#encoding: utf-8
class Store < ActiveRecord::Base
  belongs_to :city
  belongs_to :cat,:counter_cache=>'stores_count'
  attr_accessible :auction_count, :cid, :commission_rate, :created, :delivery_score, :item_score, :pic_path, :seller_credit, :seller_id, :nick, :service_score, :shop_id, :shop_title, :shop_type, :total_auction, :taoke_updated_at, :shop_updated_at,:city_id,:bulletin,:desc,:sid,:title,:modified,:click_url,:user_id,:short,
    :buyer_credit, :hangye,:seller_rate,:extra_data,
    :user_updated_at, :comments_updated_at,:delta,
    :source_url,:follow_count,:inhome,:position
  scope :updated,where('shop_updated_at is not null')
  scope :credit,order('seller_credit desc')
  scope :recent,order('id desc')
  scope :priority_asc,order('sites_stores.priority asc')
  scope :rate_desc,order('commission_rate desc')
  scope :with_priority,select('stores.*,sites_stores.priority')
  scope :short,select('stores.title,stores.id,stores.city_id,stores.seller_credit,click_url,user_id')
  scope :list_field,select('stores.title,stores.id,stores.city_id,seller_credit,click_url,pic_path,sid,nick,user_id')
  scope :incity,lambda{|city|
    if city.present?
      where(
        :city_id=> (city.parent_id>0 or city.zhixiashi?) ? city.id : City.where(:parent_id=>city.id).pluck(:id)
      )
    end
  }

  acts_as_commentable
  acts_as_taggable

  belongs_to :category,:foreign_key => 'cid',:primary_key => 'cid'

  #after_create :init_data
  before_save :check_short
  def check_short
    self[:short] = title if short.nil?
  end

  define_index do
    indexes :title,:bulletin,:desc
    #indexes :title
    has :id
    has :cat_id
    has :city_id,:facets=>true
    has :seller_credit,:facets=>true
    has :total_auction
    has :commission_rate
    where sanitize_sql(["active", true])
    set_property :delta => ThinkingSphinx::Deltas::ResqueDelta
  end

  sphinx_scope :value_desc do
    {:order=> "total_auction * commission_rate",:sort_mode=>:expr}
  end
  sphinx_scope :credit_desc do
    {:order=> "seller_credit DESC, @relevance DESC"}
  end
  sphinx_scope :srecent do
    {:order=> "id DESC, @relevance DESC"}
  end
  sphinx_scope :fullscan do
    {:match_mode=>:fullscan}
  end
  sphinx_scope :in_city do |city|
    if city.present?
      {:with=>{
        :city_id=> (city.parent_id>0 or city.zhixiashi?) ? city.id : City.where(:parent_id=>city.id).pluck(:id)
      }}
    else
      {}
    end
  end
  def name
    title
  end
  def short
    self[:short] || title
  end
  def safe_title
    title.nil? ? 'n/a' : title.gsub(/成人用品/,'成用')
  end
  def city_with_count
    [city,read_attribute(:count)]
  end
  def mingan?
    @mingan ||= (title.match(/成人用品|性福|性用品|情趣/)) ? true : false
  end
  def init_data
    #Resque.enqueue(ShopdataQueue,id,false)
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
    hash = OpenTaobao.get(
      :method => "taobao.shop.get",
      :fields => "sid,cid,title,nick,desc,bulletin,pic_path,created,modified",
      :nick => nick)
    return 
    return if rs == false
    if TaobaoFu.is_error? rs 
      if TaobaoFu.error_code == 7
        raise rs
      elsif TaobaoFu.error_code == 560
        if rs["error_response"]["sub_code"] == "isv.user-not-exist:invalid-nick"
          # nick 出错 
          Resque.enqueue FixNick,id
          return
        elsif rs["error_response"]["sub_code"] == 'isv.invalid-parameter:user-without-shop'
          update_attribute :active,false 
          return
        end
      end
      raise
    end
    rs["shop"].delete("shop_score").each do |k,v|
      rs["shop"][k] = v
    end
    rs["shop"]["shop_updated_at"] = Time.now
    update_attributes rs["shop"]
  end
  def fix_nick
    raise if user_id.nil?
    url = "http://rate.taobao.com/user-rate-#{user_id}.htm"
    require 'open-uri'
    open(url) do |f|
      f.each_line do |line|
        if m = line.match(/<title>(.*)购买心得评价/) and m.present?
          update_attribute :nick,m[1]
          Resque.enqueue(ShopdataQueue,id,false)
          return
        end
      end
    end
    raise 
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
      Resque.redis.expire cached_items_key,86400
    else
      Rails.logger.info "shop.update_items:notice:#{results.inspect}"
    end
  end
  def cached_items_key
    "shop:items:#{id}"
  end
  def items_stale?
    Resque.redis.ttl(cached_items_key) < 0
  end
  def remove_stale_items
    Resque.redis.del cached_items_key if items_stale?
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
    sid.present? ? "http://shop#{sid}.taobao.com" : "http://store.taobao.com/shop/view_shop.htm?user_number_id=#{user_id}"
  end
  def user_url
    "http://rate.taobao.com/user-rate-#{user_id}.htm"
  end
  def pic_url
    pic_path.present? ? "http://logo.taobaocdn.com/shop-logo#{pic_path}" : "loading.gif"
  end
  def city_slug
    city ? city.slug : "www"
  end

  def api
    @api ||= TaobaoFu::Api.new
  end
  class << self
    def import_by_url str
      if data = Taobao.parse_url(str)
        e = self.where(nick: data[:nick]).first_or_initialize data
        e.new_record? ?  e.save : e.update_attributes(data) 
        e
      end
    end
    def by_cats
      rs = {}
      select('id,short,title,user_id,city_id,click_url,sid,nick,pic_path,cat_id').where(inhome: true).order('position desc').includes(:city).all.each do |r|
        rs.has_key?(r.cat_id) ? 
          rs[r.cat_id] << r :
          rs[r.cat_id] = [r]
      end
      rs
    end
    def inhome_by_cats json = true
      cats = Cat.select('name,slug,id,position').roots.all
      stores = by_cats
      cats.sort{|a,b| a.position <=> b.position}
      if json
        arr = cats.collect{|cat| [cat.id,[cat,
            (stores[cat.id].nil? ? [] : stores[cat.id])]]}
        Hash[arr]
        else
        arr = cats.collect{|cat| [cat,stores[cat.id]]}
        #arr.delete_if{|r| r[1].nil?}
        Hash[arr]
      end
    end
    def all_by_ids ids
      shops = Store.where(:id=>ids).includes(:city).all
      results = []
      ids.each do |id|
        id = id.to_i
        shops.each do |r| 
          if r.id == id
            results << r
            break
          end
        end
      end
      results
    end
    def import_by_username_and_city uname,city
      e = where(:nick=>uname).first_or_initialize :city_id=>city.id,:delta=>:false
      if e.new_record?
        e.save
        e.init_data
      end
      e
    end
    def import_by_uname_and_cityname uname,cityname = nil
      e = where(:nick=>uname).first_or_initialize
      if e.new_record?
        e.city = City.find_by_name cityname unless cityname.nil?
        e.save
        e.init_data
      end
      e
    end
    def api_search cat_id
      hash = OpenTaobao.get(
        method: 'taobao.tbk.shops.get',
        fields: 'user_id,seller_nick,shop_title,pic_url,shop_url',
        cid: cat_id,
        sort_field: 'total_auction',
        sort_type: 'desc'
      )
      hash.key?('tbk_shops_get_response') ? 
        hash['tbk_shops_get_response']['tbk_shops']['tbk_shop'] :
        []
    end
    def build_by_nick nick
      e = where(:nick=>nick).first_or_initialize
      if e.new_record?
        hash = OpenTaobao.get(
          :method => "taobao.tbk.shops.detail.get",
          fields: 'user_id,shop_title,pic_url',
          :seller_nicks => nick)
        #if hash.key?("error_response")
          #e.errors.add :nick,hash["error_response"]["msg"]
          #return e
        #end
        data = hash["tbk_shops_detail_get_response"]["tbk_shops"]["tbk_shop"].first rescue nil
        if data.nil?
          e.errors.add :nick,"没有找到相应的店铺。请确认卖家昵称正确，并已加入淘宝客推广联盟。"
          return e
        end
        data["pic_path"] = data.delete("pic_url").sub('http://logo.taobaocdn.com/shop-logo','')
        data["title"] = data.delete("shop_title")
        e.update_attributes data
      else
        e.errors.add :nick,"此店铺已存在"
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
    def async_import_from_taoke data
      Resque.enqueue Store::ShopImport,data
    end
    def fix_seller_credits
      where("seller_credit > 0").find_each do |s|
        s.update_attribute :seller_credit,nil
        s.delay(:priority=>0).import_taokeshopdata
      end
    end
  end
  class ShopImport
    @queue = 'shop_import'
    def self.perform data
      Store.import_from_taoke data
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
      options.symbolize_keys!
      options[:page_no] = page
      results = api.taobaoke_shops_get cid,options.to_options

      if results["total_results"] > 0
        shops = results["taobaoke_shops"]["taobaoke_shop"]
        shops.each do |s|
          #Store.async_import_from_taoke s
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
    def clean_redis
      key = "queue:taoshop"
      len = Resque.redis.llen key
      arr = Resque.redis.lrange key,0,len
      arr.uniq.each do |val|
        Resque.redis.lrem key,0,val
        Resque.redis.rpush key,val
      end
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
      #keep_time 0.6 do
      Store::TaokeShop.new.fetch_by_cid cid,page,run_next,options
      #end
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
    def self.parse_url url
      target = url
      if target.match(/tmall\.com/)
        target = target.match(/^http:\/\/.+?\.(taobao|tmall)\.com/)[0]
        target += '/?tbpm=3'
        shop_type = 'B'
      end
      response = Typhoeus::Request.get(url,followlocation: true,verbose: false)
      if response.success?
        data = {}
        if matches = response.body.scan(/\"(shopId|userId|user_nick|shopCategoryId)\": *"(.+?)"/i)
          matches = Hash[matches]
          data = {
            sid: matches["shopId"],
            user_id: matches["userId"],
            nick: CGI.unescape(matches["user_nick"]),
            cid: matches["shopCategoryId"]
          }
        end
        doc = Nokogiri::HTML(response.body)
        if node = doc.at_css('.shop-logo img')
          data[:pic_path] = node.attr('src')
        elsif node = doc.at_css('img.logo-img')
          data[:pic_path] = node.attr('src')
        end
        if node = doc.at_css('a.shop-name')
          data[:title] = node.text.strip
          data[:source_url] = node.attr('href')
        else
          data[:title] = doc.at_css('title').text.strip
          if node = doc.at_css('a.hCard')
            data[:source_url] = node.attr('href')
          end
        end
        #data[:short] = data[:title]
        if node = doc.at_css('img.rank')
          arr = node.attr('src').match(/s_(.+?)_(\d)\.gif/)
          ranks = %w(red blue cap crown)
          data[:seller_credit] = ranks.index(arr[1]) * 5 + arr[2].to_i
        end
        if node = doc.at_css('.follow-count')
          data[:follow_count] = node.text()
        end
        data[:source_url] ||= url
        shop_type ||= data[:source_url].match(/tmall\.com/) ? "B" : "C"
        data[:shop_type] = shop_type
        data.each do |k,v|
          data.delete(k) if v.nil?
        end
        data 
      else
        nil
      end
    end
  end

end
