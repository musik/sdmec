# -*- encoding : utf-8 -*-
class Ad
  IDS = [16]
  attr_accessor :id
  def initialize id
    @id = id
  end  
  def items
    rs = Kts.get(cache_key)
    delay.update_items if rs.nil?
    rs
  end
  def cache_key
    "ad-#{@id}"
  end
  def update_items
     Kts.write cache_key do
      fetch_items
    end
  end
  def fetch_items
    api = TaobaoFu::Api.new
    api.taoke_get_items_by_keyword "",:cid=> @id
  end
  
  
end
