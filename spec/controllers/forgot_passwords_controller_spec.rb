require 'rails_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with a blank input" do
      before { post :create, email: "" }

      it "redirects to forgot passwords page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "sets a flash error message" do
        expect(flash[:danger]).to eq("Email cannot be blank.")
      end
    end

    context "with an existing email input" do
      let!(:user) { Fabricate(:user, email: "test@example.com")}
      before { post :create, email: "test@example.com" }

      it "redirects to password reset confirmation page" do
        expect(response).to redirect_to confirm_password_reset_path
      end

      it "sends out an email to the address" do
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq(["test@example.com"])
      end
    end

    context "with a non-existing email input" do
      before { post :create, email: "hello@example.com" }

      it "redirects to forgot passwords page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "sets a flash error message" do
        expect(flash[:danger]).to eq("The email you entered does not exist in our system.")
      end
    end

    context "when user is already signed in" do
      before do
        sets_current_user
        post :create, email: "test@example.com"
      end

      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end

      it "sets a flash error message" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end
end