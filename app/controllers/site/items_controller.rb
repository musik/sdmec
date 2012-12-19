class Site::ItemsController < ApplicationController
  before_filter :auth_settings
  def index
  end
  def apisearch
    @iq = params[:iq]
    api = TaobaoFu::Api.new
    results = api.taoke_get_items_by_keyword(@iq)
    @results = {}
    if results["total_results"].to_i > 0
      results["taobaoke_items"]["taobaoke_item"].each do |item|
        @results[item['num_iid']] = item
      end
      exists = @site.items.where(:num_iid => @results.keys).pluck(:num_iid)
      exists.each do |key|
        @results[key.to_i]['class'] = "added"
      end
    end
    render :layout=>false
  end

  def manage
    @items = @site.items.top.limit(30)
  end

  def add
    @item = @site.add_item params[:item]
    @items = @site.items.top.limit(30)
    render :layout=>false
  end
  def destroy
    @item = Item.find(params[:id])
    @site.items.delete @item
    render :layout=>false
  end
  def auth_settings
    authorize! :settings,@site
    TaobaoFu.use_front_key
  end
end
