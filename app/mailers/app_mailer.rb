class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Welcome to Myflix!"
  end

  def send_forgot_password_email(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Myflix Password Reset"
  end
end