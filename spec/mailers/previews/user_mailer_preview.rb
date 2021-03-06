# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(User.first)
  end

  def verify_email
    UserMailer.verify_email(User.first)
  end

  def confirmation_email
    UserMailer.confirmation_email(User.first)
  end
end
