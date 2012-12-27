class ShopdataQueue
  @queue = :shopdata
  def self.perform id,xtao=true
    #keep_time 0.9 do
      Store.find(id).import_shopdata 
      Resque.enqueue(ShopxtaoQueue,id) if xtao
    #end
  end
end
