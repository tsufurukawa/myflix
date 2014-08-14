require 'rails_helper'

describe StripeWrapper do
  let(:valid_token) { Stripe::Token.create(card: { number: "4242424242424242", exp_month: 8, exp_year: 2016, cvc: "314" }).id }
  let(:declined_card_token) { Stripe::Token.create(card: { number: "4000000000000002", exp_month: 8, exp_year: 2016, cvc: "314" }).id }

  describe StripeWrapper::Charge do
    describe ".create" do
      context "with valid credit card" do
        it "charges the card successfully", :vcr do
          charge = StripeWrapper::Charge.create(amount: 300, card: valid_token, description: "valid charge")
          expect(charge.successful?).to be_truthy
        end
      end

      context "with declined credit card" do
        it "does not charge the card successfully", :vcr do
          charge = StripeWrapper::Charge.create(amount: 300, card: declined_card_token, description: "invalid charge")
          expect(charge.successful?).to be_falsy
        end

        it "contains an error message", :vcr do
          charge = StripeWrapper::Charge.create(amount: 300, card: declined_card_token, description: "invalid charge")
          expect(charge.error_message).to eq("Your card was declined.")
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    let(:alice) { Fabricate(:user) }

    context "with valid credit card" do
      let(:response) { StripeWrapper::Customer.create(user: alice, card: valid_token) }

      it "creates a customer with valid card", :vcr do
        expect(response.successful?).to be_truthy
      end

      it "contains a customer token", :vcr do
        expect(response.customer_token).to be_present
      end
    end

    context "with declined credit card" do
      let(:response) { StripeWrapper::Customer.create(user: alice, card: declined_card_token) }

      it "does not create a customer with declined card", :vcr do
        expect(response.successful?).to be_falsy
      end

      it "contains an error message for declined card", :vcr do
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end