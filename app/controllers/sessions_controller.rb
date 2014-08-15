class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  before_action :require_non_signed_in_user, only: [:new]

  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:success] = "Welcome #{user.name}!! You successfully signed in."
        redirect_to home_path
      else
        flash[:danger] = "Your account has been suspended. Please contact customer service."
        redirect_to sign_in_path
      end
    else
      flash[:danger] = "Invalid email or password. Please try again."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "You've logged out."
    redirect_to root_path 
  end
end