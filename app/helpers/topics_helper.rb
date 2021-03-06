# -*- encoding : utf-8 -*-
module TopicsHelper
  def resort_items items
    rs = (items["taobaoke_items"]["taobaoke_item"] rescue items)
    rs.sort{|a,b|
      if a['commission_volume'] == b['commission_volume']
        b['commission'].to_f<=>a['commission'].to_f
      else
        b['commission_volume'].to_f<=>a['commission_volume'].to_f
      end
      # b['commission'].to_f<=>a['commission'].to_f
     }
    # items["taobaoke_items"]["taobaoke_item"]
  end
  def taokq_url name
    #"http://s8.taobao.com/browse/search_auction.htm?q=#{name}&pid=mm_10894158_0_0&search_type=auction&commend=all&at_topsearch=1&unid=#{name}&spm=2014.12060575.1.0"
    "http://s8.taobao.com/search?q=#{CGI.escape(name)}&cat=0&pid=mm_10894158_2495491_10807334&mode=23&commend=1%2C2&other_filter=tk_rate%5B1000%2C%5D&fs=1"
  end
end
