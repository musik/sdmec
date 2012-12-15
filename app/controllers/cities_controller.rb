# -*- encoding : utf-8 -*-
class CitiesController < ApplicationController
  load_resource :find_by => :slug,:except=>[:index]
  authorize_resource :except=>[:index]
  def index
    respond_to do |format|
      format.html
      format.text {render :layout=>false}
      #format.text { render text: CGI.unescape(_join_cities(@results)) }
      format.json {
        @results = {}
        City.select('name,slug').all.each do |r|
          @results[CGI.escape(r.name)] = r.slug
        end
        render json: CGI.unescape(@results.to_json) 
      }
    end    
  end

  def show
  end

  def new
    @city = City.new
  end

  def create
    @city = City.new(params[:city])
    if @city.save
      redirect_to @city, :notice => "Successfully created city."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @city.update_attributes(params[:city])
      redirect_to @city, :notice  => "Successfully updated city."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @city.destroy
    redirect_to cities_url, :notice => "Successfully destroyed city."
  end
end
