# -*- encoding : utf-8 -*-
class TbpagesController < ApplicationController
  load_resource :find_by => :slug,:except=>[:fenlei]
  authorize_resource :except=>[:fenlei]
  cache_sweeper :tbpage_sweeper
  def index
    @tbpages = Tbpage.all
  end
  def fenlei
    @id = params[:id].to_i(36)
    @cat = Tbpage::Temai.new.get_cat_by_id @id
    @items = Tbpage::Temai.new.get_items_by_cat @id

    breadcrumbs.add @cat["parent"]["sub_cat_name"],fenlei_link(@cat["parent"]) if @cat.has_key?("parent")
    breadcrumbs.add @cat["sub_cat_name"]
  end

  def show
  end

  def new
    @tbpage = Tbpage.new
  end

  def create
    if @tbpage.save
      redirect_to tbpages_url, :notice => "Successfully created tbpage."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @tbpage.update_attributes(params[:tbpage])
      redirect_to tbpages_url, :notice  => "Successfully updated tbpage."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @tbpage.destroy
    redirect_to tbpages_url, :notice => "Successfully destroyed tbpage."
  end
end
