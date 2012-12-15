class ShopxtaoQueue
  @queue = :shopxtao
  @retry_limit = 3
  @retry_delay = 30
  def self.perform id
    keep_time 0.6 do
      Store.find(id).import_taokeshopdata 
    end
  end
end
