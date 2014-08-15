class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Welcome to Myflix!"
  end

  def send_forgot_password_email(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Myflix Password Reset"
  end

  def send_invitation_email(invitation_id)
    @invitation = Invitation.find(invitation_id)
    mail from: 'info@myflix.com', to: @invitation.recipient_email, subject: "Myflix Invitation"
  end

  def send_account_deactivation_notification_email(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Myflix Account Deactivation"
  end
end