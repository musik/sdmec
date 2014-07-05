# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  #before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => t('Not authorized as an administrator.')
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

end
