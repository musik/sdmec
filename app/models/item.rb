# -*- encoding : utf-8 -*-
class Item < ActiveRecord::Base
  attr_accessible :cid, :click_url, :commission, :commission_num, :commission_rate, :commission_volume,
   :delist_time, :desc, :detail_url, :express_fee, :item_imgs, :item_location,
   :location_city, :location_state, :nick, :num_iid, :pic_url, :price, :sell_promise,
   :seller_credit_score, :shop_click_url, :title, :volume,:detail_updated_at
  def import_detail data
    loc = data["item"].delete "location"
    loc.each do |k,v|
      data["item"]["location_#{k}"] = v
    end
    data["item"]["detail_updated_at"] = Time.now
    update_attributes data["item"]
  end
  def update_detail
    api = TaobaoFu::Api.new
    logger.debug num_iid
    rs2 = api.taoke_items_detail_get num_iid
    logger.debug rs2.inspect
    import_detail rs2["taobaoke_item_details"]["taobaoke_item_detail"].first
  end
  def photo_url(width=160)
    "#{pic_url}_#{width}x#{width}.jpg"
  end
  def go_url
    "/link/#{num_iid}"
  end
 class << self
  def import_by_cid cid,city=nil
    api = TaobaoFu::Api.new
    options = {}
    if city.present?
      options[:area] = city.name
    end
    rs = api.taoke_get_items_by_cid(cid,options)
    import_taoke_results rs,cid
  end
  def import_by_keyword str
    api = TaobaoFu::Api.new
    rs = api.taoke_get_items_by_keyword(str)
    import_taoke_results rs
  end
  def import_taoke_results rs,cid=nil
    if rs.present? and rs["total_results"].to_i > 0
      rs["taobaoke_items"]["taobaoke_item"].collect do |data|
        data["cid"] = cid if cid.present?
        import_taobaoke_item data
      end
    else
      nil
    end
  end
  def import_taobaoke_item data
    logger.debug data
    data["title"].gsub!(/<.+?>/,'')
    data["num_iid"] = data["num_iid"].to_s
    e = where(:num_iid=>data["num_iid"]).first
    e.present? ? e.update_attributes(data) : e=create(data)
    #e.delay.
    e
  end
 end
end
