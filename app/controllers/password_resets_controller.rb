class PasswordResetsController < ApplicationController
  def show
    user = User.find_by_token(params[:id])

    if user
      @token = user.token
    else
      redirect_to invalid_token_path
    end
  end

  def create
    user = User.find_by_token(params[:token])
    
    # token exists and validation passes
    if user && user.update(password: params[:password])
      user.generate_token
      user.save
      flash[:success] = "Your password has been changed. Please sign in."
      redirect_to sign_in_path
    # token exists but validation fails
    elsif user && user.errors.any?
      # modify this code if we introduce more password validations
      flash[:danger] = "#{user.errors.full_messages.first}"
      redirect_to password_reset_path(user.token)
    # token doesn't exist
    else
      redirect_to invalid_token_path
    end
  end
end