class PagesController < ApplicationController
  include HighVoltage::StaticPage
  rescue_from ActionView::MissingTemplate do |exception|
    if exception.message =~ %r{Missing template #{page_finder.content_path}}
      raise ActionController::RoutingError, "No page: #{params[:id]}"
    else
      raise exception
    end
  end
end
