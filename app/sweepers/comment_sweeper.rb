# -*- encoding : utf-8 -*-
class CommentSweeper < ActionController::Caching::Sweeper
  observe Comment # This sweeper is going to keep an eye on the r model

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
    if r.commentable_type == 'Store'
      expire_page :controller=>"stores",:action=>"show",:id=>r.commentable_id
    end
  end
end
