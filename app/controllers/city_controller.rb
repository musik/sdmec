# -*- encoding : utf-8 -*-
class CityController < ApplicationController
  #before_filter :find_city
  protected
  def _find_city
    @city = City.find_by_slug(request.subdomain)
    if @city.nil?
      redirect_to root_url(:subdomain=>"www") and return
    end
    @navs = [
      'lady',
        'yifu',
        'xiezi',
        'baobao',
        'peishi',
        'meirong',
        'jiaju',
      'muying',
      'men',
    ]
  end
end
