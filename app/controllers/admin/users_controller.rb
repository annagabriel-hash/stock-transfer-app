class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update approve]
  before_action :authenticate_user!, :require_admin

  def index
    @users = User.all
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = 'You have successfully update the user'
      redirect_to admin_user_path
    else
      render :edit
    end
  end

  def approve
    @user.approved!
  end

  private

  def require_admin
    return if current_user.admin?

    flash[:alert] = 'You are not authorized to perform that action'
    redirect_to root_path
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, role_ids: [])
  end
end
