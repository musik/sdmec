#-*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :add_initial_breadcrumbs
  after_filter :store_location
  layout :smart_layout
  #,:reload_rails_admin
  include UrlHelper
  rescue_from CanCan::AccessDenied do |exception|
    logger.debug exception
    redirect_to root_path, :alert => exception.message
  end

  private
  def store_location
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end
  def reload_rails_admin
    return unless rails_admin_path?
    models = %W(User UserProfile)
    models.each do |m|
      RailsAdmin::Config.reset_model(m)
    end
    RailsAdmin::Config::Actions.reset

    load("#{Rails.root}/config/initializers/rails_admin.rb")
  end

  def rails_admin_path?
    controller_path =~ /rails_admin/ && Rails.env == "development"
  end
  def add_initial_breadcrumbs
    return if request.url.match("/admin") 
    if request.subdomain.blank? 
      return
      elsif CitySubdomain.matches? request
        find_city
      elsif SiteSubdomain.matches? request
        find_site
      elsif Subdomain.matches? request
        redirect_to url_for(:subdomain=>'www'),:status=>301
    end
    breadcrumbs.add :home, root_url(:subdomain=>'www'),:rel=>"nofollow"
    if @city.present?
      breadcrumbs.add @city.parent.name,root_url(:subdomain=>@city.parent.slug),:title=>"#{@city.parent.name}网" unless @city.parent_id.zero?
    breadcrumbs.add @city.name, root_url(:subdomain=>@city.slug),:rel=>"nofollow" 
    end

    
    if %(links users registrations sessions).include? controller_name
      @hide_ad = true
      @hide_fullad = @col1 = @hide_belt = @hide_bread = true
    end 
    if %(entries).include? controller_name
      _parse_ref
    end
    if %(new edit).include? action_name
      @hide_sidebar_ad = 1
    end
  end
  def find_city
    @city = City.find_by_slug(request.subdomain)
    if @city.nil?
      redirect_to root_url(:subdomain=>"www") and return
    end
  end
  def find_site
    @site = Site.find_by_slug(params[:id])
    if @site.nil?
      redirect_to new_site_url(:subdomain=>'www',:slug=>request.subdomain),:notice=>'你访问的小站暂不存在！'
    else
      @layout = 'site'
    end

  end
  def render_503(exception = nil)
    @hidead = true
    render :file => "error/503",:layout=>'error', :status => 503, :headers=>{"Retry-after" => 86400}
    
  end
  def _empty_referer?
    request.env["HTTP_REFERER"].blank?
  end
  def smart_layout 
    @layout || 'application'
  end
  def _parse_ref
    return if request.referer.nil?
    refuri = URI(request.referer)
    return if refuri.host.match(/\.(baidu.com|sogou.com|so.com|sdmec.com|42foo.com)/).present?
    entry = Entry.find_by_host(refuri.host)
    return if entry.nil?
    entry.update_attribute :clicked_at,Time.now
  end

end
