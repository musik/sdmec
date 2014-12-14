class Fl::PostsController < ApplicationController
  before_action :set_fl_post, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @fl_posts = Fl::Post.all
    respond_with(@fl_posts)
  end

  def show
    respond_with(@fl_post)
  end

  def new
    @fl_post = Fl::Post.new
    respond_with(@fl_post)
  end

  def edit
  end

  def create
    @fl_post = Fl::Post.new(post_params)
    flash[:notice] = 'Fl::Post was successfully created.' if @fl_post.save
    respond_with(@fl_post)
  end

  def update
    flash[:notice] = 'Fl::Post was successfully updated.' if @fl_post.update(post_params)
    respond_with(@fl_post)
  end

  def destroy
    @fl_post.destroy
    respond_with(@fl_post)
  end

  private
    def set_fl_post
      @fl_post = Fl::Post.find(params[:id])
    end

    def fl_post_params
      params.require(:fl_post).permit(:title, :summary, :keywords, :content, :user_id, :city_id, :published_at, :publish, :category_id)
    end
end
