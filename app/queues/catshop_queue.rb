class CatshopQueue
  @queue = :catshop
  def self.perform cat_id
    keep_time 0.6 do
      cat = Category.find cat_id
      cat.import_shops
    end
  end
end
