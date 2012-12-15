# -*- encoding : utf-8 -*-
class CategoriesController < ApplicationController
  load_resource :except=>[:show,:edit,:update,:admin]
  authorize_resource :except=>[]
  def index
    params[:page] ||= 1
    @categories = Category.page(params[:page]).per(160)
    breadcrumbs.add :categorys, nil,:class=>'active'
  end
  def admin
    params[:page] ||= 1
    breadcrumbs.add :categories, admin_categories_url
    breadcrumbs.add :roots, admin_categories_url(:roots=>true)
    @categories = Category.order("priority desc").page(params[:page]).per(160).includes(:parent)
    if params[:roots]
    elsif params[:parent_id]
      @category = Category.find(params[:parent_id])
      @categories = @categories.where(:parent_id => @category.id)
      @title = @category.name
      if @category.child?
        @category.ancestors.each do |c|
          breadcrumbs.add c.name,admin_categories_url(:parent_id=>c.id)
        end
      end
      breadcrumbs.add @category.name,nil
    else
      @categories = @categories.roots
    end
  end

  def show
    @category = Category.find_by_smart params[:id]
    @city = Subdomain.matches?(request) ? City.find_by_slug(request.subdomain) : nil

    @items = @category.items.order("commission_volume desc").page(params[:page] || 1).per(40)
    @title = @city.present? ? "#{@city.name} #{@category.name}" : @category.name

    unless @category.root?
      breadcrumbs.add @category.parent_name,url_for(@category.parent)
    end
    breadcrumbs.add @category.name,nil
  end

  def new
  end

  def create
    if @category.save
      redirect_to @category, :notice => "Successfully created category."
    else
      render :action => 'new'
    end
  end

  def edit
    @category = Category.find_by_smart params[:id]
    breadcrumbs.add :categories, admin_categories_url
    breadcrumbs.add :roots, admin_categories_url(:roots=>true)
  end

  def update
    @category = Category.find_by_smart params[:id]
    if @category.update_attributes(params[:category])
      redirect_to admin_categories_url, :notice  => "Successfully updated category."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @category = Category.find_by_smart params[:id]
    @category.destroy
    redirect_to categorys_url, :notice => "Successfully destroyed category."
  end

  def go
    url = params[:id].reverse
    redirect_to url
  end
end
