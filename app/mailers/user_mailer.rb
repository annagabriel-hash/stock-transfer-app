class UserMailer < ApplicationMailer
  default from: 'notifications@stocktransferapp.com'

  def welcome_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: 'Welcome to the Stock App'
    )
  end

  def verify_email(user)
    @user = user
    @url = user_confirm_url(user.id)
    mail(
      to: @user.email,
      subject: 'Stock App - Verify account'
    )
  end
end
