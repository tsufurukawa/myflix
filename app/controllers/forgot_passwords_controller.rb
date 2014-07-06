class ForgotPasswordsController < ApplicationController
  before_action :require_non_signed_in_user

  def create
    user = User.find_by(email: params[:email])

    if user
      AppMailer.send_forgot_password_email(user).deliver
      redirect_to confirm_password_reset_path
    else
      flash[:danger] = set_flash_error_message(params[:email])
      redirect_to forgot_password_path
    end
  end

  private

  def set_flash_error_message(email_param)
    email_param.blank? ? "Email cannot be blank." : "The email you entered does not exist in our system."  
  end
end