# -*- encoding : utf-8 -*-
class TbpagesController < ApplicationController
  load_resource #:find_by => :slug,:except=>[]
  authorize_resource :except=>[]
  cache_sweeper :tbpage_sweeper
  def index
    @tbpages = Tbpage.all
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
