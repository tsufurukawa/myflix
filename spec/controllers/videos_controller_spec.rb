require 'rails_helper'

describe VideosController do 
  describe "GET index" do 
    it "sets the @categories variable for authenticated users" do 
      sets_current_user
      comedy = Category.create(name: 'comedy')
      drama = Category.create(name: 'drama')
      get :index
      expect(assigns(:categories)).to include(comedy, drama)
    end

    it_behaves_like "require_sign_in" do 
      let(:action) do 
        comedy = Category.create(name: 'comedy')
        drama = Category.create(name: 'drama')
        get :index
      end
    end
  end

  describe "GET show" do
    context "for authenticated users" do 
      let(:video1) { Fabricate(:video) }
      let(:video2) { Fabricate(:video) }
      let(:review1) { Fabricate(:review, video: video2, created_at: 5.minutes.ago) }
      let(:review2) { Fabricate(:review, video: video2, created_at: 3.minutes.ago) }

      before do 
        sets_current_user
        get :show, id: video2.id
      end

      it "sets the @video variable" do 
        expect(assigns(:video)).to eq(video2)
      end

      it "sets @reviews variable" do 
        expect(assigns(:reviews)).to match_array([review1, review2])
      end

      it "sets @reviews ordered by created_at reverse chronologically" do 
        expect(assigns(:reviews)).to eq([review2, review1])
      end
    end
    
    it_behaves_like "require_sign_in" do 
      let(:action) do 
        video = Fabricate(:video)
        get :show, id: video.id
      end
    end
  end

  describe "GET search" do 
    let(:video) { Fabricate(:video, title: 'Futurama') } 
    let(:action) { get :search, search: 'uTURAm' }

    it "sets the @search_videos variable for authenticated users" do 
      sets_current_user
      action
      expect(assigns(:search_videos)).to eq([video])  
    end

    it_behaves_like "require_sign_in"
  end
end
