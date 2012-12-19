
class Site::ShopsController < ApplicationController
  def index
  end

  def manage
    @stores = @site.shops.rate_desc.limit(30)
  end

  def destroy
    @shop = Store.find(params[:id])
    #@site.shops.delete @shop
    render :layout=>false
  end

  def apisearch
    @iq = params[:iq]
    api = TaobaoFu::Api.new
    results = api.taobaoke_shops_get('',:keyword=>@iq)
    @results = {}
    if results["total_results"].to_i > 0
      results["taobaoke_shops"]["taobaoke_shop"].each do |shop|
        @results[shop['user_id']] = shop
      end
      exists = @site.shops.where(:user_id => @results.keys).pluck(:user_id)
      exists.each do |key|
        @results[key.to_i]['class'] = "added"
      end
    end
    render :layout=>false
  end

  def add
    @shop = @site.add_shop params[:shop]
    @shops = @site.shops.with_priority.priority_asc.limit(30)
    render :layout=>false
  end
  respond_to :json
  def update
    @shop = Store.find params[:id]
    SiteStore.set_priority @site.id,@shop.id,params[:store][:priority]
    @shops = @site.shops.with_priority.priority_asc.limit(30)
    respond_with @shop
  end
end
