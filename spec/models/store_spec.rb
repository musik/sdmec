#encoding: utf-8
require 'spec_helper'

describe Store do
  it "should jie" do
    %w(http://store.taobao.com/shop/view_shop.htm?user_number_id=116043003 http://store.taobao.com/shop/view_shop.htm?user_number_id=228784630 http://osa.tmall.com http://eraserdiary.taobao.com/ http://linnan.taobao.com/ http://peipeiwangluofushi.taobao.com/ http://shop57831817.taobao.com/).each do |url|
      #pp  Store.import_by_url url
    end
    #Store::Taobao.parse_url('http://shop217225.taobao.com/')
    #Store::Taobao.parse_url('http://ripfs.tmall.com/')
    #Store::Taobao.parse_url('http://dageyaosha.taobao.com/')
    #e = Store.build_by_nick "韩都衣舍旗舰店"
    #p e
    #e.import_shopdata
    #city = City.create :name=>"曲靖"
    #Store::Jie.new.search_by_city city.id,1,false
    #e = Store.import_by_username_and_city "usedcar",city
    #e = Store.create :nick=>'y_camping',:user_id=>66781367
    #e.update_items
    #e = Store.create :nick=>'古臣轩旗舰店',:user_id=>765416082
    #e.import_shopdata
    #e.fix_nick
    #e.import_taokeshopdata
    #pp e

    #Store::Jie.new.search_by_city city

    #Store::Jie.new.run_all_cities
  end
  it "should create" do
    #s = Store.create :user_id=>195066088
    #s.update_items
    #pp s.cached_items
    #s = Store.create :nick=>"lawe263"
    #s.import_shopuser
    #p Store.first
    #s.import_shopdata
    #pp s
    #s.import_taokeshopdata
    #pp s
    #s.import_comments 
    #Store::TaokeShop.new.run
    #Store::TaokeShop.new.fetch_by_cid 14,1,false
    #Store::TaokeShop.new.fetch_by_cid 14,1,true,:start_credit=>'1diamond',:end_credit=>'1diamond' 
    #pp Store::TaokeShop.new.count_cats
    #pp Store::TaokeShop.new.credits_options
    #pp Store::TaokeShop.new.rate_options
    #pp Store::TaokeShop.new.clean_redis

  end     
  it "should fetch user" do
    # Store::Taobao.new.fetch_user "27984093"
  end     
end
