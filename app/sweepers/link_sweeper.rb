# -*- encoding : utf-8 -*-
class LinkSweeper < ActionController::Caching::Sweeper
  observe Link # This sweeper is going to keep an eye on the r model

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
    expire_page :controller=>"links",:action=>"show",:id=>r.id,:format=>:json
    Rails.cache.delete 'all_links'
    Rails.cache.delete  'category-sidebar'
  end
end
