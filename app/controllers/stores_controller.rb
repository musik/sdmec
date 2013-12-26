#encoding: utf-8
class StoresController < ApplicationController
  caches_action :show,:expires_in => 1.days
  cache_sweeper :store_sweeper
  caches_action :city,:expires_in => 5.minutes 
  caches_action :index,:top,
    :expires_in => 1.hour,
    :cache_path => Proc.new { |c| c.params }
  caches_action :recent,
    :expires_in => 3.minutes,
    :cache_path => Proc.new { |c| c.params }
    #:expires_in => Proc.new { |c|
      #c.params[:page].present? && c.params[:page] > 10 ?
        #3.days : 1.hour
    #},   
  # GET /stores
  # GET /stores.json
  def check_out_page
    if params.has_key?(:page) && params[:page].to_i > 100 
      @out_page = true
      @title = "不显示100页以后的内容"
      params.delete :page
      render :status=>410
    end
  end
  def index
    check_out_page
    @stores = Store.value_desc.fullscan.search :include=>[:city],
      :per_page=>100,
      :page=>params[:page] || 1, :max_matches => 10_000
    @title = "店铺"
    @hide_recent = true
    breadcrumbs.add "店铺",nil
  end
  def find
    @cat = Cat.find params[:cat_id]
    @stores = Store.credit_desc.search params[:sq],
      #:without => {:id=>@cat.id},
      :include=>[:cat],
      :per_page => 30, 
      :page=>(params[:page] || 1)
  end
  def city
    check_out_page
    @stores = Store.srecent.in_city(@city).fullscan.search :per_page=>100,
      :include=>[:city],
      :page=>params[:page] || 1
    @title = "#{@city.name}店铺"
    breadcrumbs.add "店铺",nil
    @hide_recent = true
    render :action=>:index
  end
  def recent
    check_out_page
    @stores = Store.srecent.fullscan.search :include=>[:city],
      :per_page=>100,
      :page=>params[:page] || 1, :max_matches => 10_000
    @stores = @stores.in_city(@city) if @city
    @title = "最新收录的店铺"
      @title = @city.name + @title if @city.present?
    @hide_recent = true
    breadcrumbs.add "最新收录",nil
    render :index
  end
  def top 
    check_out_page
    @stores = Store.credit_desc.fullscan.search :include=>[:city],
      :per_page=>100,
      :page=>params[:page] || 1
    @stores = @stores.in_city(@city) if @city
      @title = "店铺排行榜"
      @title = @city.name + @title if @city.present?
    #pages = (@stores.total_entries / 100).ceil
    #@max_page = @city.present? ? 10 : 100
    #@max_page = pages if pages < @max_page
    breadcrumbs.add "店铺",stores_url
    breadcrumbs.add "排行榜",nil
    @hide_top = true
    render :action=>"huangguan"
  end
  def dengji
    @dengji = params[:dengji].to_i
    @stores = Store.value_desc.fullscan.search :include=>[:city],
      :with=>{:seller_credit=>@dengji.to_i},
      :per_page=>200,
      :page=>params[:page] || 1
    arr = %w(金冠 皇冠 钻石 心).reverse
    @dengjiming = arr[((@dengji-1)/5).to_i]
    @dengjishu = (@dengji).divmod(5)[1]
    @dengjishu = 5 if @dengjishu.zero?
    @title = "#{@dengjishu}#{@dengjiming}店铺"
    breadcrumbs.add "店铺",stores_url
    breadcrumbs.add "名店",top_stores_url
    breadcrumbs.add @title,nil
    render :action=>'huangguan'
  end
  def huangguan
    @cap = params[:cap]
    @stores = Store.credit_desc.fullscan.search :include=>[:city],
      :with=>{:seller_credit=>10 + @cap.to_i},
      :per_page=>200,
      :page=>params[:page] || 1
    @title = "#{@cap}皇冠店铺"
    breadcrumbs.add "店铺",stores_url
    breadcrumbs.add "名店",top_stores_url
    breadcrumbs.add @title,nil
    render :action=>'huangguan'
  end
  def jinhuangguan
    @stores = Store.value_desc.fullscan.search :include=>[:city],
      :with=>{:seller_credit=>16..20},
      :per_page=>200,
      :page=>params[:page] || 1
    @title = "金皇冠店铺"
    breadcrumbs.add "店铺",stores_url
    breadcrumbs.add "名店",top_stores_url
    breadcrumbs.add @title,nil
    render :action=>'huangguan'
  end
  def submit
    @store = Store.new
    breadcrumbs.add "店铺提交"
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
    @store = Store.find(params[:id])
    if @store.title.nil?
      @store.init_data
      render :text=>'503',:status=>503
      return
    end
    #logger.debug @store.inspect
    #if @store.mingan?
      #redirect_to @store.url
      #return
    #end
    @cano = store_url(@store,:subdomain=>@store.city_slug)
    if @store.city_slug != 'www'
      unless @city.present? and @city.slug == @store.city_slug
        redirect_to @cano
        return
      end
    end

    @tags = @store.tag_list
    #@store.sync_update_taokedata if @store.user_id.nil?
    #@items = @store.cached_items
    #@store.remove_stale_items
    #@items = nil
    breadcrumbs.add @store.title,nil
    #render  @store.click_url.present? ? 'newshow' : 'freeshow'
    #render  'newshow'
    render 'weshow'
  end
  def patch
    if cookies[:sign].present?
      @store = Store.find(params[:id])
      @store.update_attributes params[:shop]
      expire_action :action=>'show',:id=>@store.id
      render :text => 'updated'
    else
      render :text => 'invalid put'
    end
  end
  def items
    @store = Store.find(params[:id])
    if params[:update].present?
      TaobaoFu.use_front_key
      @store.update_items
      expire_action :action=>'show',:id=>@store.id if @store.cached_items.present?
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
  def flush
    expire_action :action=>:show,:id=>params[:id]
    redirect_to :action=>:show,:id=>params[:id]
  end
  def convert
    @store = Store.find(params[:id])
    respond_to do |format|
      format.js
    end
  end


  # GET /stores/new
  # GET /stores/new.json
  def new
    @store = Store.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store }
    end
  end

  # GET /stores/1/edit
  def edit
    @store = Store.find(params[:id])
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.build_by_nick(params[:store][:nick])

    respond_to do |format|
      if @store.errors.messages.empty?
        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        format.json { render json: @store, status: :created, location: @store }
      else
        format.html {
          @tmp = @store
          @store = Store.new(nick: @tmp.nick)
          @store.errors.add :nick,@tmp.errors.messages[:nick][0]
          render action: "submit" 
        }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stores/1
  # PUT /stores/1.json
  def update
    @store = Store.find(params[:id])

    respond_to do |format|
      if @store.update_attributes(params[:store])
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store = Store.find(params[:id])
    @store.destroy

    respond_to do |format|
      format.html { redirect_to stores_url }
      format.json { head :no_content }
    end
  end
end
