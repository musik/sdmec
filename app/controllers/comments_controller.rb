
class CommentsController < ApplicationController
  cache_sweeper :comment_sweeper
  # GET /comments
  # GET /comments.json
  authorize_resource
  def index
    @comments = Comment.order("id desc").page(params[:page] || 1).includes(:commentable).per(25)
    breadcrumbs.add :comments,nil

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    return if _empty_referer?
    args = params[:comment]
    @commentable = eval(args.delete("commentable_type")).find args.delete("commentable_id")
    
    @comment = @commentable.root_comments.new(args)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to "#{url_for(@commentable)}#comment-#{@comment.id}"}
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render "#{url_for(@commentable)}#new_comment"}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end
end
