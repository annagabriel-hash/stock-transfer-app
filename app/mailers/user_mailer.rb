class UserMailer < ApplicationMailer
  default from: 'notifications@stocktransferapp.com'

  def welcome_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: 'Welcome to the Stock App'
    )
  end
end
