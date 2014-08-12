require 'rails_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      let(:token) { Stripe::Token.create(card: { number: card_number, exp_month: 8, exp_year: 2016, cvc: "314" }).id }

      context "with valid credit card" do
        let(:card_number) { "4242424242424242" }

        it "charges the card successfully", :vcr do
          charge = StripeWrapper::Charge.create(amount: 300, card: token, description: "valid charge")
          expect(charge.successful?).to be_truthy
        end
      end

      context "with declined credit card" do
        let(:card_number) { "4000000000000002" }

        it "does not charge the card successfully", :vcr do
          charge = StripeWrapper::Charge.create(amount: 300, card: token, description: "invalid charge")
          expect(charge.successful?).to be_falsy
        end

        it "contains an error message", :vcr do
          charge = StripeWrapper::Charge.create(amount: 300, card: token, description: "invalid charge")
          expect(charge.error_message).to eq("Your card was declined.")
        end
      end
    end
  end
end