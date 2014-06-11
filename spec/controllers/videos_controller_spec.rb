require 'rails_helper'

describe VideosController do 
  describe "GET show" do 
    it "sets the @video variable for authenticated users" do 
      session[:user_id] = Fabricate(:user).id
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      get :show, id: video2.id
      expect(assigns(:video)).to eq(video2)
    end
    
    it "redirects to sign in page for unauthenticated users" do 
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET search" do 
    it "sets the @search_videos variable for authenticated users" do 
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video, title: 'Futurama')
      get :search, search: 'uTURAm'
      expect(assigns(:search_videos)).to eq([video])  
    end

    it "redirects to sign in page for unauthenticated users" do 
      video = Fabricate(:video, title: 'Futurama')
      get :search, search: 'uTURAm'
      expect(response).to redirect_to sign_in_path
    end
  end
end
