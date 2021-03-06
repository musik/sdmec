# -*- encoding : utf-8 -*-
class City::HomeController < CityController
  caches_action :index,:page,
      :expires_in => 8.hour,
      :cache_path => Proc.new { |c| c.params }

  def index
    @cities = @city.children_or_siblings
    breadcrumbs.add @city.name, nil,:class=>'active'
    @col1 = true
  end
  def index_old
    #@items = Item.order("commission_volume desc").limit(40)
    @cities = @city.children_or_siblings
    breadcrumbs.add @city.name, nil,:class=>'active'
    #@hide_whole = true
    #@shout = true
    @col1 = true
    @noad = true
  end
  def page
    @page = Tbpage.find_by_slug params[:id]
    @items = @page.items

    breadcrumbs.add @page.name,nil
  end
end
