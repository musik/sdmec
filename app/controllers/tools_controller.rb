#encoding: utf-8
class ToolsController < ApplicationController
  include TaobaoHelper
  def xiaoliang
    _xiaoliang_parse_submit
    @title = "淘宝店铺销量分析"
    @page_title ||= "淘宝店铺销量分析"
  end
  def _xiaoliang_parse_submit
    if params[:name].present?
      @name = params[:name]
      match = @name.match(/^http:\/\/([\w\d]+)\.(taobao|tmall)\.com/)
      if !match
        @store = Store.where(nick: @name).first
        (redirect_to xiaoliang_url(@store.id) and return ) if @store.present?
        @url = find_shopurl_by_nick(@name)
        return nil if @url.nil?
      else
        @url = match.to_s
      end
      _fetch_xiaoliang_by_url @url
    end
    if params[:id].present?
      @store = Store.find params[:id]
      @page_title = @store.title
      @page_title += "销量分析_淘宝店铺销量分析"
      @name = @store.nick
      _fetch_xiaoliang_by_url @store.shop_url
    end
  end
  def _fetch_xiaoliang_by_url url
    @url = url
    @data = parse_shop_by_url url
    if @data.present?
      @data[:vols] = (@data[:label] == false) ? false : true
      @data[:label] = '月销量' unless @data[:label].present?

      @realurl = @data[:realurl] || url
      if @data[:name].present?
        @page_title = @data[:name]
        @page_title += "_#{@page_title}销量分析_淘宝店铺销量分析"
      end
    else
      @realurl = url
    end
  end
end
