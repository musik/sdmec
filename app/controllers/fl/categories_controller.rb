class Fl::CategoriesController < ApplicationController
  before_action :set_fl_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @fl_categories = Fl::Category.all
    respond_with(@fl_categories)
  end

  def show
    respond_with(@fl_category)
  end
  def city
    @category = Fl::Category.where(slug: params[:id]).first
  end
  def new
    @fl_category = Fl::Category.new
    respond_with(@fl_category)
  end

  def edit
  end

  def create
    @fl_category = Fl::Category.new(category_params)
    flash[:notice] = 'Fl::Category was successfully created.' if @fl_category.save
    respond_with(@fl_category)
  end

  def update
    flash[:notice] = 'Fl::Category was successfully updated.' if @fl_category.update(category_params)
    respond_with(@fl_category)
  end

  def destroy
    @fl_category.destroy
    respond_with(@fl_category)
  end

  private
    def set_fl_category
      @fl_category = Fl::Category.find(params[:id])
    end

    def fl_category_params
      params.require(:fl_category).permit(:name, :slug, :keywords)
    end
end
