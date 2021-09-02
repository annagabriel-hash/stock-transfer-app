class UsersController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @stock = Stock.new
  end

  def verify
    UserMailer.verify_email(current_user).deliver_later
    flash[:notice] = 'Verification email sent'
    redirect_to root_path
  end

  def confirm
    @user = User.find(params[:id])
  end

  def upgrade
    @user = User.find(params[:id])
    @user.upgrade_account
    flash[:notice] = 'You have successfully updated your account'
    redirect_to root_path
  end
end
