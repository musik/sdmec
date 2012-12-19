# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  include CityHelper,ApplicationHelper
  caches_action :index,:expires_in => 1.minutes
  caches_action :city,:expires_in => 30.minutes

  def index
    @stores = Store.credit_desc.fullscan.search :include=>[:city],:per_page=>100
    @stores_recent = Store.srecent.fullscan.search :include=>[:city],:per_page=>51
    @hide_bread = true
  end
  def xtao
    _set_xtao_cookie
    render :nothing=>true
  end
  def index_20121128
    @stores = Store.srecent.fullscan.search :include=>[:city],:per_page=>90
    @hide_bread = true
  end
  def city
    @stores = Store.credit_desc.in_city(@city).fullscan.search :include=>[:city],:per_page=>10

    @cities = @city.children_or_siblings unless @city.zhixiashi?

  end
  def site

  end
  def search
    @q = params[:q]
    if @q.match(/成人|性福|性用品|情趣/)
      redirect_to "http://s8.taobao.com/search?q=#{CGI.escape(@q)}&cat=0&pid=mm_10894158_2495491_10807334&mode=23&commend=1%2C2&other_filter=tk_rate%5B1000%2C%5D&fs=1"
      return
    end
    if params[:live] && @q.present?
      @s = Searched.create(:query=>@q,:created_at=>Time.now)

      if params[:tb]
        redirect_to "http://s8.taobao.com/search?q=#{CGI.escape(@q)}&cat=0&pid=mm_10894158_2495491_10807334&mode=23&commend=1%2C2&other_filter=tk_rate%5B1000%2C%5D&fs=1"
        else
        redirect_to search_url(:q=>@q)
      end
      return
    end
    @stores = Store.credit_desc.search @q,:include=>[:city],:per_page=>10,
      :page=>params[:page] || 1
    

    breadcrumbs.add @q
  end
  def searched
    @current_page = params[:page] || 1
    @per_page =250
    @searched = Searched.page(@current_page.to_i,@per_page)
    @total_pages = (Searched.all.size/@per_page).ceil
  end
  def index_old
    # @items = Tbpage.all_items
    @items = Item.order("commission_volume desc").limit(40)
    @cities = City.cached_roots
    #@hide_whole = true
    @hide_bread = true
   # @noad  = true
   # @col1 = true
  end
  def page
    @page = Tbpage.find_by_slug params[:id]
    @items = @page.items

    breadcrumbs.add @page.name,nil
  end
  def item_go
    @item = Item.find_by_num_iid params[:nid]
    redirect_to @item.click_url
  end
  def store_go
    @store= Store.find params[:id]
    redirect_to @store.real_url
  end
  def ad
    params[:num] ||= 4
    params[:num] = params[:num].to_i if params[:num].is_a? String
    @cid = params[:id]

    @ad = Ad.new @cid
    @items = @ad.items#.slice(0,params[:num])

    if request.xhr? or params[:ajax]
      render :layout=>false
    end
    # render :json=>@ad.items
  end
  def flush
    params[:act] ||= 'index'
    expire_action :action=>params[:act]
    render :text=>params[:act]
  end
  def status

  end
  def zhuan
    @url = params[:url]
    if @url
      @nid = @url.match(/\d+/)[0]

      api = TaobaoFu::Api.new
      results = api.taoke_convert_items @nid
      @item = results['taobaoke_items_convert_response']['taobaoke_items']['taobaoke_item'].first rescue nil
    end
  end
  def deleted
    render :file => "error/410",:layout=>'error', :status => 410
  end
end
