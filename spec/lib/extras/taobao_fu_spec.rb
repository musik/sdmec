# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../../spec_helper'

describe TaobaoFu do
  it "should be valid" do
    # items = TaobaoFu.get(:method => 'taobao.items.get',
               # :q    => 'htc',
               # # :fields => 'num_iid,title,nick,pic_url,cid,price,type,delist_time,post_fee,score,volume',
               # :fields => 'num_iid,title,nick,price,volume'
               # )
    # iids = items["items_get_response"]["items"]["item"].collect{|item| item["num_iid"]}
    # res = TaobaoFu.get(:method => 'taobao.taobaoke.items.convert',
               # :nick    => 'usedcar',
               # :num_iids => iids.join(","),
               # # :fields => 'click_url,num_iid,commission,commission_rate,commission_num,commission_volume'
               # :fields => 'click_url,num_iid'
               # )
    # pp res["taobaoke_items_convert_response"]["taobaoke_items"]["taobaoke_item"]
#
    # for i in 1..150 do
      # pp i
      # api = TaobaoFu::Api.new
      # api.taoke_get_items_by_keyword("htc")
    # end
    #测试时间
    #api = TaobaoFu::Api.new
    #pp api.taoke_get_report :page_size=>1
    #pp api.taobaoke_shops_convert 'rongrongaijunjun'
    #pp api.taobaoke_shops_convert 'jiroren'
    # for j in 1..10 do
      # t1 = Time.now
      # pp t1
      # for i in 1..100 do
        # %w(htc).each do |str|
          # items = api.taoke_get_items_by_keyword(str,:page_size=>i)
          # # pp items
          # if items.present?
            # # pp items["total_results"]
          # else
            # pp items
          # end
          # #["taobaoke_items"]["taobaoke_item"].size
        # end
      # end
      # t2 = Time.now
      # pp t2
      # pp t2-t1
    # end

    # pp items["taobaoke_items"]["taobaoke_item"].size rescue "0"
    #pp items["taobaoke_items"]["taobaoke_item"].size

    #,:page_size=>2
    #pp api.get_products_by_keyword '手机'
    # pp api.itemcats_get(0)
    #api =  TaobaoFu::Api.new
     #pp api.itemcats_get(999)
    #pp TaobaoFu.generate_xtao_sign

  end
end
