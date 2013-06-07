#encoding: utf-8
class TagsController < ApplicationController
  before_filter :_setting
  def index
    @tags = Store.tag_counts_on(:tags)
  end
  def new
    authorize! :manage,Tag
  end
  def preview
    authorize! :manage,Tag
    @names = params[:names].split("\r\n").compact
    @exists = Tag.named_any(@names).pluck(:name)
    @results = @names.collect do |name|
      sleep 0.1
      {:name=>name,:count=>Store.search_count(name),:exists=>@exists.include?(name)}
    end
  end
  def create
    authorize! :manage,Tag
    @names = params[:tags].keys
    @tags = Tag.find_or_create_all_with_like_by_name @names
    @tags.map(&:async_autotag)
  end

  def show
    @tag = Tag.named(params[:id]).first
    @stores = Store.tagged_with(@tag.name).includes(:city).page(params[:page]).per(15)
    #@s1 = Store.tagged_with(@tag.name).pluck("stores.id")
    #@s2 = Store.search(@tag.name,:per_page=>10000).map(&:id)
    #@stores = Store.where(:id=>(@s1-@s2))

    breadcrumbs.add :tags,tags_path
    if params[:page].present?
      breadcrumbs.add @tag.name,tag_path(@tag)
      breadcrumbs.add "第#{params[:page]}页",nil
      else
      breadcrumbs.add @tag.name,nil
    end
  end
  def _setting
    @hide_searches = @hide_top = @hide_recent = true
  end
end
