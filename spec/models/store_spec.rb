#encoding: utf-8
require 'spec_helper'

describe Store do
  it "should jie" do
    #city = City.create :name=>"曲靖"
    #Store::Jie.new.search_by_city city.id,1,false
    #e = Store.import_by_username_and_city "usedcar",city
    #e.import_shopdata
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
    #Store::TaokeShop.new.fetch_by_cid 1055,39
    #Store::TaokeShop.new.fetch_by_cid 1055,38
  end     
  it "should fetch user" do
    # Store::Taobao.new.fetch_user "27984093"
  end     
end