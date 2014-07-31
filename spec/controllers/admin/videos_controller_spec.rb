require 'rails_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it_behaves_like "require_admin" do
      let(:action) { get :new }
    end

    it "sets the @video variable" do
      sets_current_admin
      get :new
      expect(assigns(:video)).to be_a_new(Video)
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    it_behaves_like "require_admin" do
      let(:action) { post :create }
    end

    context "with valid input" do
      let(:category) { Fabricate(:category) }
      before do
        sets_current_admin
        post :create, video: Fabricate.attributes_for(:video, category: category)
      end

      it "creates the video" do
        expect(category.videos.count).to eq(1)
      end

      it "redirects to add video page" do
        expect(response).to redirect_to new_admin_video_path
      end

      it "sets a flash success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      before do
        sets_current_admin
        post :create, video: { title: "Futurama" }
      end

      it "renders new video page" do
        expect(response).to render_template :new
      end

      it "does not create a video" do
        expect(Video.count).to eq(0)
      end

      it "sets the @video variable" do
        expect(assigns(:video)).to be_a_new(Video)
      end
    end
  end
end