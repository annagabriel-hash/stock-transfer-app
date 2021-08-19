class Admin::UsersController < ApplicationController
  before_action :authenticate_user!, :require_admin

  def index
    @users = User.all
  end

  def show; end

  def require_admin
    return if current_user.admin?

    flash[:alert] = 'You are not authorized to perform that action'
    redirect_to root_path
  end
end
