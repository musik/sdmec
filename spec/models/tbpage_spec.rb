# -*- encoding : utf-8 -*-
#encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe Tbpage do
  it "should be valid" do
    #Tbpage.new.should be_valid
    #Tbpage::Temai.new.get_cats
    pp Tbpage::Temai.new.update_items_by_cat 625396204
  end
  it "should " do
    # t = FactoryGirl.create :tbpage
    # # t.items.should be_nil
    # t2 = FactoryGirl.create :tbpage,:name=>"衣服",:tagid=>453
#
#
    # t.update_items
    # t2.update_items
#
    # Tbpage.all_items
    # rs = t.update_items
    # pp rs
    # pp rs.count
  end
end
