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

    if @user.save
      handle_invitation
      
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :card => params[:stripeToken],
        :description => "Sign up charge for #{@user.email}"
      )

      if charge.successful?
        AppMailer.send_welcome_email(@user).deliver
        session[:user_id] = @user.id
        flash[:success] = "Welcome #{@user.name}!! You successfully registered."
        redirect_to home_path
      else
        flash[:danger] = charge.error_message
        redirect_to register_path
      end
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

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by_token(params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end