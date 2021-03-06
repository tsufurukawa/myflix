Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    # retrieve customer id from Stripe webhook data and find the user corresponding to this id
    user = User.where(customer_token: event.data.object.customer).first
    Payment.create(user: user, amount: event.data.object.amount, reference_id: event.data.object.id)
  end

  events.subscribe 'charge.failed' do |event|
    user = User.where(customer_token: event.data.object.customer).first
    user.deactivate!
    AppMailer.delay.send_account_deactivation_notification_email(user)
  end
end