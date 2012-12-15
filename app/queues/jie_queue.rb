class JieQueue
  @queue = :jie
  @retry_limit = 3
  @retry_delay = 30
  def self.perform city_id,page
    keep_time 1.6 do
      Store::Jie.new.search_by_city city_id,page
    end
  end
end
