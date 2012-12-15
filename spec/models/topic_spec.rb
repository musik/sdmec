# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe Topic do
  it "should be valid" do
    # t = Topic.create(:name=>'巧克力') 
    # #t = Topic.where(:name=>'巧克力').first_or_create(:volume=>120)
    # Topic.create(:name=>'O.SA/欧莎').slug.should eql("O.SA-欧莎")
    # Topic.create(:name=>'O.SA/欧莎  ').slug.should eql("O.SA-欧莎-1")
    # Topic.create(:name=>' O.SA/欧莎').slug.should eql("O.SA-欧莎-2")
    # c = City.create :name=>'温州',:parent_id=>0
#     
    # # pp t.update_acrs
    # # pp t.load_items
    # # pp t.dached_items 1.second,:city=>c
    # #pp t.dached_items 1.second#,:city=>c
    # # pp t    
    # # Topic.all_update_items
    # #Topic.create(:name=>"天翼上网卡").dached_items  5.minute#,:city=>c
    # ckey = "items-0"
      # Kts.write ckey do
        # false
      # end
      # Kts.get(ckey).should eql("-1")
  end
end
