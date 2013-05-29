#encoding: utf-8
class CatStoresController < ApplicationController
  before_filter :find_cat
  def index
    @stores = Store.where(:cat_id=>@cat.id).page(params[:page] || 1)
    @title = "#{@cat.name}店铺"
    breadcrumbs.add "店铺",nil
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
    @store = Store.find(params[:store_id])
    @store.cat = @cat
    @store.save!
    #@cat.stores << @store
  end

  # PUT /stores/1
  # PUT /stores/1.json
  def update

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
    @store = @cat.stores.find(params[:id])
    @store.cat = nil
    @store.save!
    #@cat.stores.delete @store
    render :action=>"create"
  end
  def find_cat
    @cat = Cat.find params[:cat_id]
  end

end
