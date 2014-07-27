require 'rails_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it "sets the @video variable" do
      sets_current_admin
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end

    context "for non-admin user" do
      before do
        sets_current_user
        get :new
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end

      it "sets a flash error message" do
        expect(flash[:danger]).to be_present
      end
    end
  end
end