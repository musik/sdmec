# -*- encoding : utf-8 -*-

class CatsController < ApplicationController
  load_and_authorize_resource :only=>%w(update create destroy)
  caches_action :city,:expires_in => 30.minutes
  # GET /cats
  # GET /cats.json
  def manage
    @cats = Cat.page(params[:page] || 1).per(50)
    breadcrumbs.add "manage",manage_cats_url
    breadcrumbs.add "preview",preview_cats_url

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cats }
    end
  end
  def tree
    
  end
  def preview
    breadcrumbs.add "manage",manage_cats_url
    breadcrumbs.add "preview",preview_cats_url
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: Store.inhome_by_cats.to_json }
      #format.json { render json: Cat.pluck(:name).to_json }
    end
  end
  def search
    render json: Store.api_search(params[:cat_id])
  end
  def update_store
    Store.find(params[:id]).update_attributes(params[:store])
    render text: '1'
  end
  def remove_all
    Store.where("cat_id is not null").update_all(cat_id: nil)
    head :no_content
  end
  def add
    @store = Store.import_by_url(params[:shop_url])
    if @store.present? and @store.cat_id.nil?
      cat = Cat.find(params[:cat_id])
      @store.cat  = cat
      @store.save
      render json: @store.to_json
      return
    end
    head :no_content
  end

  def city
    @cat = Cat.find(params[:id])
    @stores = Store.credit_desc.in_city(@city).search @cat.name,:include=>[:city],:per_page=>10,:page=>(params[:page] || 1)
    if @stores.empty?
      @instead = true
      @stores = Store.credit_desc.search @cat.name,:include=>[:city],:per_page=>10
    end
    breadcrumbs.add "#{@cat.name}",tbcat_url(@cat,:subdomain=>"www")
  end
  # GET /cats/1
  # GET /cats/1.json
  def show
    @cat = Cat.find(params[:id])
    @stores = Store.credit_desc.search @cat.name,:include=>[:city],:per_page=>30,:page=>(params[:page])
    breadcrumbs.add "#{@cat.name}",nil
  end

  # GET /cats/new
  # GET /cats/new.json
  def new
    @cat = Cat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cat }
    end
  end

  # GET /cats/1/edit
  def edit
    @cat = Cat.find(params[:id])
  end

  # POST /cats
  # POST /cats.json
  def create
    @cat = Cat.new(params[:cat])

    respond_to do |format|
      if @cat.save
        format.html { redirect_to @cat, notice: 'Cat was successfully created.' }
        format.json { render json: @cat, status: :created, location: @cat }
      else
        format.html { render action: "new" }
        format.json { render json: @cat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cats/1
  # PUT /cats/1.json
  def update
    @cat = Cat.find(params[:id])

    respond_to do |format|
      if @cat.update_attributes(params[:cat])
        format.html { redirect_to @cat, notice: 'Cat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cats/1
  # DELETE /cats/1.json
  def destroy
    @cat = Cat.find(params[:id])
    @cat.destroy

    respond_to do |format|
      format.html { redirect_to cats_url }
      format.json { head :no_content }
    end
  end
end
