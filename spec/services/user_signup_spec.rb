require 'rails_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      before do
        customer = double(:customer, successful?: true)
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end

      after { ActionMailer::Base.deliveries.clear }

      it "creates a user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe token", nil)
        expect(User.count).to eq(1)
      end

      context "through invitation" do
        let(:inviter) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, inviter: inviter) }
        before { UserSignup.new(Fabricate.build(:user, name: "Alice")).sign_up("stripe token", invitation.token) }

        it "makes the user follow the inviter" do
          user = User.find_by_name("Alice")
          expect(user.already_following?(inviter)).to be_truthy
        end

        it "makes the inviter follow the user" do
          user = User.find_by_name("Alice")
          expect(inviter.already_following?(user)).to be_truthy
        end

        it "expires the invitation upon acceptance" do
          expect(Invitation.first.token).to be_nil
        end
      end

      context "email sending" do
        before { UserSignup.new(Fabricate.build(:user, email: "alice@example.com", name: "Alice")).sign_up("stripe token", nil) }

        it "sends out the email" do
          expect(ActionMailer::Base.deliveries).not_to be_empty    
        end

        it "sends to the right recipient" do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq(["alice@example.com"])  
        end

        it "has the right content" do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include("Welcome to Myflix, Alice")
        end
      end
    end

    context "with valid personal info and declined card" do
      it "does not create a new user record" do
        customer = double(:customer, successful?: false, error_message: "You're card was declined.")
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up("stripe token", nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do 
      it "doesn't create any user" do
        UserSignup.new(User.new(name: "Alice")).sign_up("stripe token", nil)
        expect(User.count).to eq(0)
      end

      it "does not send out the email" do
        UserSignup.new(User.new(name: "Alice")).sign_up("stripe token", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "does not charge the credit card" do
        StripeWrapper::Customer.should_not_receive(:create)
        UserSignup.new(User.new(name: "Alice")).sign_up("stripe token", nil)
      end
    end
  end
end