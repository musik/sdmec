# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe ShopSearch do
  it "should be valid" do
    #ShopSearch.new.search '食品',1,false
    Category.create :name=>'女装'
    ShopSearch.new.run_all_categories
  end
end
