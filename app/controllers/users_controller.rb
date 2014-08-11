class UsersController < ApplicationController
  before_action :can_register?, only: [:new]
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def new_with_invitation_token
    invitation = Invitation.find_by_token(params[:token])

    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to invalid_token_path
    end
  end

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])

    if result.successful?
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.name}!! You successfully registered."
      redirect_to home_path
    elsif result.declined_card?
      flash[:danger] = result.error_message
      render :new
    else
      render :new
    end
  end

  private 

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def can_register?  
    if logged_in?
      flash[:danger] = "You have already registered for an account."
      redirect_to home_path
    end
  end
end