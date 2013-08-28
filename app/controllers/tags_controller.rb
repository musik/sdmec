#encoding: utf-8
class TagsController < ApplicationController
  authorize_resource :except=>%w(preview auto_complete city)
  before_filter :_setting
  def index
    #@tags = Store.tag_counts_on(:tags,:limit=>50)
    @tags = Tag.all_tagged_on('Store').page(params[:page]).per(100)
    breadcrumbs.add "店铺分类",(params.has_key?('page') ? tags_url : nil)
  end
  def auto_complete
    @term = params[:term].strip
    @results = ThinkingSphinx.search(@term,:per_page=>10)
    Rails.logger.info @results.inspect
    classes = {
      'Store'=> nil,
      "Tag"=> "标签"
    }
    @results.collect!{|t|
      {:label=>[classes[t.class.to_s],t.name].compact.join(":"),
        :value=>(t.class.to_s == 'Tag' ? tag_url(t.name) : store_url(t,:subdomain=>'www'))}
    }
    Rails.logger.info @results

    #@tags = Tag.all_tagged_on('Store').where(["tags.name like ?","%#{@term}%"]).limit(10).collect{|t|
      #{:label=>t.name,:value=>tag_url(t.name)}
    #}
    if @results.empty?
        render :json => [{:label=>t('auto_complete.not_found'),:value=>0}].to_json
      else
        @results << {:label=>"--> 查看更多",:value=>search_url(:q=>@term,:subdomain=>'www')}
        render :json => @results.to_json
    end
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
    @stores = Store.tagged_with(@tag.name).credit.list_field.includes(:city).page(params[:page]).per(15)
    @group = Store.tagged_with(@tag.name).includes(:city).group("city_id").select("stores.id,stores.city_id,count(*) as count").having("count > ?",Rails.env.production? ? 40 : 10).map(&:city_with_count)
    breadcrumbs.add :tags,tags_path
    if params[:page].present?
      breadcrumbs.add @tag.name,tag_path(@tag)
      breadcrumbs.add "第#{params[:page]}页",nil
      else
      breadcrumbs.add @tag.name,nil
    end
  end
  def city
    @tag = Tag.named(params[:id]).first
    @stores = @city.stores.tagged_with(@tag.name).credit.list_field.includes(:city).page(params[:page]).per(15)
    @group = Store.tagged_with(@tag.name).includes(:city).group("city_id").select("stores.id,stores.city_id,count(*) as count").having("count > ?",Rails.env.production? ? 40 : 10).map(&:city_with_count)
    @breadcrumbs.items.pop
    breadcrumbs.add :tags,tags_path(:subdomain=>'www')
    breadcrumbs.add @tag.name,tag_path(@tag,:subdomain=>'www')
    breadcrumbs.add @city.name,nil
  end
  def _setting
    @hide_searches = @hide_top = @hide_recent = true
  end
end
