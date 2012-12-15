# -*- encoding : utf-8 -*-
class StoreSweeper < ActionController::Caching::Sweeper
  observe Store # This sweeper is going to keep an eye on the r model

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
    #expire_page :controller=>"stores",:action=>"show",:id=>r.id
    expire_action :controller=>"stores",:action=>"show",:id=>r.id
  end
end
