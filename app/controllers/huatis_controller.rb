# -*- encoding : utf-8 -*-

class HuatisController < ApplicationController
  load_and_authorize_resource :except => [:fetch,:visit,:search,:load_data,:auto_complete]
  
  before_filter :setbreads
  def setbreads
    if Subdomain.matches? request
      redirect_to root_url and return
    end
    breadcrumbs.add :huatis,huatis_url
    @is_huati = true
    if Rails.env.development?
      Feedzirra::Parser::BingImageEntry
      Feedzirra::Parser::BingNewsEntry
    end
  end
  # GET /huatis
  # GET /huatis.json
  def manage
    @huatis = Huati.order("id desc").page(params[:page] || 1).per(100)
    if params[:published].present?
       @huatis = @huatis.where(:published=>nil)
    end
  end
  def index
    @huatis = Huati.published.order("id desc").order("priority desc").page(params[:page] || 1).per(100)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @huatis }
    end
  end
  def browse
    @acr =params[:acr]
    @huatis = Huati.published.order("id desc").where(:acr=>@acr).order("priority desc").page(params[:page] || 1).per(100)
    @title = "#{@acr}开头"
    breadcrumbs.add @title,nil
    render :index
  end
  def search
    @huati = Huati.where(:name=>params[:q]).first_or_create
    redirect_to huati_url(@huati)
  end
  def auto_complete
    @term = params[:term]
    @rs = Huati.published.select([:name,:slug]).where(["name like ?","%#{params[:term]}%"]).limit(10)
    if @rs.empty?
        render :json => [{:label=>t('auto_complete.not_found'),:value=>0}].to_json
      else
        render :json => @rs.collect{|t| {:label=>t.name,:value=>t.slug}}.to_json  
    end
    
  end
  def visit
    @r = Huati.find params[:id]
    track_page_view(@r) unless @r.nil?
    render :nothing=>true
  end
  # GET /huatis/1
  # GET /huatis/1.json
  def show
    redirect_to huati_url(@huati) and return if @huati.id == params[:id].to_i
    @q = @huati.name

    @huati.sync_update_weibo if @huati.weibo.nil?
       
    breadcrumbs.add @huati.name
    
    render :status=>503 if @huati.weibo.nil?

  end
  def load_data
    @n = params[:n].to_i
    @n+=1
    @huati = Huati.find(params[:id])
  end
  def fetch
    @huati = Huati.find(params[:id])
    @fname = params[:fname].sub("-","/")
    Mzfetcher.get(@fname,@huati.name)
  end

  # GET /huatis/new
  # GET /huatis/new.json
  def new
    @huati = Huati.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @huati }
    end
  end

  # GET /huatis/1/edit
  def edit
    
  end

  # POST /huatis
  # POST /huatis.json
  def create
    

    respond_to do |format|
      if @huati.save
        format.html { redirect_to @huati, notice: 'Huati was successfully created.' }
        format.json { render json: @huati, status: :created, location: @huati }
      else
        format.html { render action: "new" }
        format.json { render json: @huati.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /huatis/1
  # PUT /huatis/1.json
  def update
    

    respond_to do |format|
      if @huati.update_attributes(params[:huati])
        format.html { redirect_to @huati, notice: 'Huati was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @huati.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /huatis/1
  # DELETE /huatis/1.json
  def destroy
    
    @huati.destroy

    respond_to do |format|
      format.html { redirect_to manage_huatis_url }
      format.json { head :no_content }
    end
  end
end
