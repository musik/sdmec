class FenleisController < ApplicationController
  load_and_authorize_resource
  def index
    @fenleis = Fenlei.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fenleis }
    end
  end

  # GET /fenleis/1
  # GET /fenleis/1.json
  def show
    @fenlei = Fenlei.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fenlei }
    end
  end

  # GET /fenleis/new
  # GET /fenleis/new.json
  def new
    @fenlei = Fenlei.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fenlei }
    end
  end

  # GET /fenleis/1/edit
  def edit
    @fenlei = Fenlei.find(params[:id])
  end

  # POST /fenleis
  # POST /fenleis.json
  def create
    @fenlei = Fenlei.new(params[:fenlei])

    respond_to do |format|
      if @fenlei.save
        format.html { redirect_to @fenlei, notice: 'Fenlei was successfully created.' }
        format.json { render json: @fenlei, status: :created, location: @fenlei }
      else
        format.html { render action: "new" }
        format.json { render json: @fenlei.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fenleis/1
  # PUT /fenleis/1.json
  def update
    @fenlei = Fenlei.find(params[:id])

    respond_to do |format|
      if @fenlei.update_attributes(params[:fenlei])
        format.html { redirect_to @fenlei, notice: 'Fenlei was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fenlei.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fenleis/1
  # DELETE /fenleis/1.json
  def destroy
    @fenlei = Fenlei.find(params[:id])
    @fenlei.destroy

    respond_to do |format|
      format.html { redirect_to fenleis_url }
      format.json { head :no_content }
    end
  end
end
