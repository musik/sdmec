class ShopItemsJob
  @queue = :shop_items
  def self.perform id
    keep_time 0.6 do
      Store.find(id).update_items 
    end
  end
end
