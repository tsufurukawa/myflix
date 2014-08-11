class UserSignup
  attr_reader :error_message, :user

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :card => stripe_token,
        :description => "Sign up charge for #{user.email}"
      )
      if charge.successful?
        user.save
        handle_invitation(invitation_token)
        AppMailer.send_welcome_email(user).deliver
        @status = :success
        self
      else
        @status = :declined_card
        @error_message = charge.error_message
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