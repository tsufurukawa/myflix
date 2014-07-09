require 'rails_helper'

describe PasswordResetsController do
  describe "GET show" do
    let(:user) { Fabricate(:user) }
    before { user.update_column(:token, "some token") }

    it "renders show template for valid token" do
      get :show, id: "some token"
      expect(response).to render_template :show
    end

    it "sets the @token variable" do
      get :show, id: "some token"
      expect(assigns[:token]).to eq("some token")
    end

    it "redirects to expired token page for invalid token" do
      get :show, id: "another token"
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "POST create" do
    context "with valid token and valid password" do
      let(:user) { Fabricate(:user, password: "password") }

      before do
        user.update_column(:token, "some token")
        post :create, token: "some token", password: "another password"
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end

      it "sets a flash success message" do
        expect(flash[:success]).to be_present
      end

      it "updates the user password" do
        expect(user.reload.authenticate("another password")).to be_truthy
      end

      it "regenerates the user token" do
        expect(user.reload.token).not_to eq("some token")
      end
    end

    context "with valid token but invalid password" do
      let(:user) { Fabricate(:user, password: "password") }
      
      before do
        user.update_column(:token, "some token")
        post :create, token: "some token", password: "a"
      end

      it "redirects to password reset show page" do
        expect(response).to redirect_to password_reset_path(user.token)
      end

      it "sets a flash error message" do
        expect(flash[:danger]).to be_present
      end
    end

    context "with invalid token" do
      it "redirects to expired token page" do
        post :create, token: "some token", password: "another password"
        expect(response).to redirect_to invalid_token_path
      end
    end
  end
end