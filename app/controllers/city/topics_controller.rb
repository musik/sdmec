# -*- encoding : utf-8 -*-
class City::TopicsController < CityController
  caches_action :index,:browse,:popular,
      :expires_in => 8.hour,
      :cache_path => Proc.new { |c| c.params }
  caches_action :show,
      :expires_in => 7.days,
      :cache_path => Proc.new { |c| c.params }
  # load_and_authorize_resource
  load_resource :find_by => :slug,:except=>[:show,:city_visit]
  authorize_resource :except=>[:index,:show,:go,:search,:auto_complete,:city_visit,:popular]


  def index
    params[:page] ||= 1
    # @topics = Topic.fetched_in_city(@city).page(params[:page]).per(160)
    @topics = Topic.publics.fetched.page(params[:page]).per(160).order("id desc")
      # joins("left join cts on cts.city_id = #{@city.id} and cts.topic_id = topics.id").
      # order("cts.items_count desc")
    # @topics = Topic.page(params[:page]).order("volume desc")
    breadcrumbs.add @city.name, nil,:class=>'active'
  end
  def popular
    @pvs = Tc.top(@city.id).page(params[:page] || 1).per(160)
    @topics = Tc.topics_from_pvs(@pvs)
    # breadcrumbs.add :topics, topics_url
    breadcrumbs.add :popular, nil,:class=>'active'

    # @hide_whole = true
  end

  def search
    # redirect_to "/mai/#{params[:q]}"
    @topic = Topic.find_by_slug params[:q]
    @topic = Topic.create(:name=>params[:q]) if @topic.nil?
    redirect_to topic_url(@topic,:subdomain=>@city.slug)
    # redirect_to topic_url(params[:q])
  end
  def browse
    params[:page] ||= 1
    @acr = params[:i]
    @topics = Topic.fetched_in_city(@city).where(:acr=>@acr).page(params[:page]).per(160)
      # .
      # joins("left join cts on cts.city_id = #{@city.id} and cts.topic_id = topics.id").
      # order("cts.items_count desc")

    breadcrumbs.add @city.name, root_url
    breadcrumbs.add @acr, nil,:class=>"active"
  end

  def show
    if params[:id] == 'city_visit'
      render :nothing=>true
      return
    end
    params[:id] = CGI.unescape params[:id]
    @topic = Topic.find_by_slug(params[:id])
    @topic = Topic.new(:name=>params[:id]) if @topic.nil?

    # params[:page] ||= 1
    @items = @topic.dached_items APP_CONFIG[:expires_in_city],:city=>@city#,:page_no=>params[:page]
    # @items = @topic.items :city=>@city#,:page_no=>params[:page]
    if @items.present? and @items.keys.size == 1
      @items = []
    end
    unless @items.present?
      @replaced = true
      # unless @city.parent_id < 1
        # @parent_city = City.find @city.parent_id
        # @nitems = @topic.dached_items APP_CONFIG[:expires_in_city],:city=>@parent_city
        # @replaced = !@nitems.present?
      # end
      @items = @topic.dached_items APP_CONFIG[:expires_in] if @replaced
    end
    # logger.info @items



    breadcrumbs.add @topic.name, url_for(:subdomain=>'www')
    if @city.parent_id > 0
      @parent_city = City.find @city.parent_id
      breadcrumbs.add @parent_city.name, url_for(:subdomain=>@parent_city.slug)
    end
    breadcrumbs.add @city.name, nil,:class=>"active"
    @hide_whole = true
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
    redirect_to topics_url, :notice => "Successfully destroyed topic."
  end
  def city_visit
    if params[:topic].present?
      @topic = Topic.find_by_slug params[:topic]
      if @topic.present?
        @tc = Tc.where(:topic_id=>@topic.id,:city_id=>@city.id).first_or_create
        track_page_view(@tc)
      end
    end
    track_page_view(@city) unless @city.nil?
    render :nothing=>true
  end

end
