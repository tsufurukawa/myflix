require 'rails_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with a blank input" do 
      it "redirects to forgot passwords page" do
        post :create, email: ""
        expect(response).to redirect_to forgot_password_path
      end

      it "sets a flash error message" do
        post :create, email: ""
        expect(flash[:danger]).to eq("Email cannot be blank.")
      end
    end

    context "with an existing email input" do
      it "redirects to password reset confirmation page" do
        user = Fabricate(:user, email: "test@example.com")
        post :create, email: "test@example.com"
        expect(response).to redirect_to confirm_password_reset_path
      end

      it "sends out an email to the address" do
        user = Fabricate(:user, email: "test@example.com")
        post :create, email: "test@example.com"
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq(["test@example.com"])
      end
    end

    context "with a non-existing email input" do
      it "redirects to forgot passwords page" do
        post :create, email: "hello@example.com"
        expect(response).to redirect_to forgot_password_path
      end

      it "sets a flash error message" do
        post :create, email: "hello@example.com"
        expect(flash[:danger]).to eq("The email you entered does not exist in our system.")
      end
    end

    context "when user is already signed in" do
      it "redirects to home page" do
        sets_current_user
        post :create, email: "test@example.com"
        expect(response).to redirect_to home_path
      end

      it "sets a flash error message" do
        sets_current_user
        post :create, email: "test@example.com"
        expect(flash[:danger]).not_to be_blank
      end
    end
  end
end