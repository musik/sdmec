# -*- encoding : utf-8 -*-
class Tbpage < ActiveRecord::Base
  attr_accessible :name, :slug, :tburl, :last_fetched_at,:tagid
  acts_as_url :name,  :url_attribute=>:slug#,  :only_when_blank=>true
  resourcify
  after_create :delayed_update
  
  def delayed_update
    delay.update_items
  end
  
  def cached_items expires_in=1.day
    Kts.fetch cache_key,:expires_in => expires_in do
      rs = fetch_items
      if rs != false
        update_attribute :last_fetched_at,Time.now
      end
      rs
    end
  end
  def items
    rs = Kts.get(cache_key)
    delayed_update if rs.nil?
    rs
  end
  def cache_key
    "tbpage-items-#{id}"
  end
  def update_items
     Kts.write cache_key do
      rs = []
      for i in 4..6
        rs += fetch_items :order=> i
      end
      if rs != false
        update_attribute :last_fetched_at,Time.now
      end
      rs
    end
  end
  def fetch_items options={}
    res = Typhoeus::Request.get build_query(options.merge(:tagid=>tagid))
    # pp res.body.encoding
    data = JSON.parse(HTMLEntities.new.decode(res.body.encode('UTF-8','GBK')))
    rs = data["itemList"]
    rs2 = {}
    rs.each do |r|
      rs2[r["itemId"]] = r
    end
    rs3 = TaobaoFu::Api.new.get_items_data rs2.keys.join(",")
    return false unless rs3.present?
    rs4 = []
    rs3.each do |r|
      r["data"] = rs2[r["num_iid"]]
      rs4 << r
    end     
    rs4
  end
  def build_query(args = {})
    defaults={
      :page=>1,
      :order=>4
    }
    defaults.merge! args
    'http://love.taobao.com/guang/async_search.htm?' + defaults.to_query
  end
  class << self
    
    def cached_all
      Rails.cache.fetch "all_tbpages" do
        all
      end
    end
    def all_items
      rs = {}
      all.each{|r| rs[r.cache_key] = r}
      @kt = Kts.db_init
      rs2 = {}
      @kt.get_bulk(rs.keys).each do |k,v|
        next if v.nil?
        rs2[rs[k]] = %w([ {).include?(v[0,1]) ? eval(v) : v 
      end
      rs2
    end
  end
  class Temai
    @queue = "temai"
    def cats_key
      @cats_key ||= "temai:cats"
    end
    def data_key name
      "temai:#{name}"
    end
    def get_cats
      @cats ||= begin
        results = Resque.redis.get cats_key
        if results.nil?
          async(:update_cats)
          nil
        else
          JSON.parse results
        end
      end
    end
    def all_cats
      @all_cats ||= begin
        @cats = get_cats
        @cats + @cats.collect{|c| c["children"]}.flatten
      end
    end
    def get_cat_by_id id
      @cats = get_cats
      cat = @cats.select{|r|
        r["sub_cat_id"] == id
      }.first
      if cat.nil?
         childrens = @cats.collect{|c| 
           c["children"]
         }
         cat = childrens.flatten.select{|r|
            r["sub_cat_id"] == id
          }.first
         return if cat.nil?
         parent = @cats.select{|r|
          r["children"].include? cat
         }.first
         cat["siblings"] = parent.delete "children"
         cat["parent"] = parent
         Rails.logger.debug cat
      end
      cat
    end
    def get_cats_with_items
      @cats = get_cats
      return nil if @cats.nil?
      @cats.collect do |cat|
        cat["items"] = get_items_by_cat(cat["sub_cat_id"])
        cat
      end
    end
    def get_items_by_cat id
      @items ||= []
      @items[id] ||= begin
        results = Resque.redis.get data_key("items:#{id}")
        if results.nil?
          async(:update_items_by_cat,id)
          nil
        else
          JSON.parse results
        end
       end
      @items[id]
    end
    def update_items_by_cat id
      api = TaobaoFu::Api.new
      results = api.tmall_temai_items_search :cat=>id
      results["items"] = results["item_list"]["tmall_search_tm_item"] 
      results.delete "item_list"
      Resque.redis.set data_key("items:#{id}"),results.to_json
      results
    end
    def update_cats
      api = TaobaoFu::Api.new
      results = api.tmall_temai_cats
      Resque.redis.set cats_key,results.to_json
      all_cats.each do |cat|
        async :update_items_by_cat,cat["sub_cat_id"]
      end
      results
    end
    def self.perform(method, *args)
      new.send(method, *args)
    end
    def async(method, *args)
      Resque.enqueue(Tbpage::Temai, method, *args)
    end
  end
end
