# -*- encoding : utf-8 -*-
class TbpageSweeper < ActionController::Caching::Sweeper
  observe Tbpage # This sweeper is going to keep an eye on the r model
 
  def after_create(r)
    expire_cache_for(r)
  end
 
  def after_update(r)
    expire_cache_for(r)
  end
 
  def after_destroy(r)
    expire_cache_for(r)
  end
 
  private
  def expire_cache_for(r)
    Rails.cache.delete 'all_tbpages'
  end
end
