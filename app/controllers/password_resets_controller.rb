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
    
    if user && user.update(password: params[:password])
      user.generate_token
      user.save
      flash[:success] = "Your password has been changed. Please sign in."
      redirect_to sign_in_path
    elsif user && user.errors.any?
      # modify this code if we introduce more password validations
      flash[:danger] = "#{user.errors.full_messages.first}"
      redirect_to password_reset_path(user.token)
    else
      redirect_to invalid_token_path
    end
  end
end