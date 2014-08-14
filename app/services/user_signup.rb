class UserSignup
  attr_reader :error_message, :user

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if user.valid?
      customer = StripeWrapper::Customer.create(
        user: user,
        card: stripe_token
      )
      if customer.successful?
        user.customer_token = customer.customer_token
        user.save
        handle_invitation(invitation_token)
        AppMailer.send_welcome_email(user).deliver
        @status = :success
        self
      else
        @status = :declined_card
        @error_message = customer.error_message
        self
      end
    else
      @status = :invalid_personal_info
      self
    end
  end

  def successful?
    @status == :success
  end

  def declined_card?
    @status == :declined_card
  end

  private

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by_token(invitation_token)
      user.follow(invitation.inviter)
      invitation.inviter.follow(user)
      invitation.update_column(:token, nil)
    end
  end
end