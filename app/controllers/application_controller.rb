#-*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :add_initial_breadcrumbs
  #,:reload_rails_admin
  include UrlHelper
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  private
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
   # Rack::MiniProfiler.authorize_request if Rails.env.development?
    if request.subdomain.blank? 
      #redirect_to url_for(:subdomain=>'www'),:status=>301
      return
      elsif Subdomain.matches? request
        find_city
    end
    breadcrumbs.add :home, root_url(:subdomain=>'www'),:rel=>"nofollow"
    if @city.present?
      breadcrumbs.add @city.parent.name,root_url(:subdomain=>@city.parent.slug),:title=>"#{@city.parent.name}淘宝网" unless @city.parent_id.zero?
    breadcrumbs.add @city.name, root_url(:subdomain=>@city.slug),:rel=>"nofollow" 
    end

    
    if %(links).include? controller_name
      @hide_ad = true
    end 
  end
  def find_city
    @city = City.find_by_slug(request.subdomain)
    if @city.nil?
      redirect_to root_url(:subdomain=>"www") and return
    end
  end
  def render_503(exception = nil)
    @hidead = true
    render :file => "error/503",:layout=>'error', :status => 503, :headers=>{"Retry-after" => 86400}
    
  end
  def _empty_referer?
    request.env["HTTP_REFERER"].blank?
  end

end
