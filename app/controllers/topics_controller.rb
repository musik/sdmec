# -*- encoding : utf-8 -*-
class TopicsController < ApplicationController
  caches_action :index,:browse,:auto_complete,:popular,
      :expires_in => 8.hour, 
      :cache_path => Proc.new { |c| c.params }
  #caches_action :show,:expires_in => 2.days,:cache_path => Proc.new { |c| c.params }
  # load_and_authorize_resource
  load_resource :find_by => :slug,:except=>[:show,:go,:visit]
  authorize_resource :except=>[:index,:show,:go,:search,:auto_complete,:visit,:popular]
  def index
    params[:page] ||= 1
    @topics = Topic.publics.fetched.page(params[:page]).per(160).order("id desc")
    # @topics = Topic.page(params[:page]).order("volume desc")
    breadcrumbs.add :topics, nil,:class=>'active'
  end
  def manage
    @topics = Topic.order("created_at desc").page(params[:page] || 1).per(160)
    @hide_whole = true
  end
  def popular
    @topics = PageView.get_top_in(Topic).page(params[:page] || 1).per(160)
    # breadcrumbs.add :topics, topics_url
    breadcrumbs.add :popular, nil,:class=>'active'
    
    # @hide_whole = true
  end
  def browse
    params[:page] ||= 1
    @acr = params[:i]
    @topics = Topic.publics.fetched.where(:acr=>@acr).page(params[:page]).per(160)#.order("volume desc")
    breadcrumbs.add t("breadcrumbs.browse",:acr=>@acr.upcase), nil,:class=>'active'
  end
  def search
    @topic = Topic.find_by_slug params[:q]
    @topic = Topic.create(:name=>params[:q]) if @topic.nil?
    redirect_to topic_url(@topic)  
  end
  def auto_complete
    @term = params[:term]
    @topics = Topic.publics.select([:name,:slug]).where(["name like ?","%#{params[:term]}%"]).limit(10)
    # @topics = Topic.search(@term,
        # # :page=>params[:page],
        # # :include=>[:company],
        # :sort_mode => :extended,
        # :order => "@relevance DESC",
        # :per_page => 15)
    unless @topics.collect{|t| t.name}.include? @term
      @topic = Topic.select([:name,:slug]).where(["name = ?",params[:term]]).first
      @topics.unshift @topic if @topic.present? 
    end
    if @topics.empty?
        render :json => [{:label=>t('auto_complete.not_found'),:value=>0}].to_json
      else
        render :json => @topics.collect{|t| {:label=>t.name,:value=>t.slug}}.to_json  
    end
    
  end

  def show
    params[:id] = CGI.unescape params[:id]
    @topic = Topic.find_by_slug params[:id]
    @topic = Topic.new(:name=>params[:id]) if @topic.nil?
     
    
    # params[:page] ||= 1
    # @items = @topic.items #APP_CONFIG[:expires_in]#,:page_no=>params[:page]
    @items = @topic.dached_items APP_CONFIG[:expires_in]
    # logger.info @items
    breadcrumbs.add @topic.name, nil,:class=>'active'
  end
  def visit
    @topic = Topic.find_by_slug params[:id]
    track_page_view(@topic) unless @topic.nil?
    render :nothing=>true
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      redirect_to @topic, :notice => "Successfully created topic."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @topic.update_attributes(params[:topic])
      redirect_to @topic, :notice  => "Successfully updated topic."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, :notice => "Successfully destroyed topic." }
      format.js
    end
  end
  def publish
    @topic.update_attribute :public,true
    respond_to do |format|
      format.html { redirect_to topics_url, :notice => "Successfully published topic." }
      format.js
    end
  end
  
  def go
    url = params[:id].reverse
    redirect_to url
  end
end
