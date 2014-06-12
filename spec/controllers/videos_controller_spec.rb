require 'rails_helper'

describe VideosController do 
  describe "GET index" do 
    it "sets the @categories variable for authenticated users" do 
      session[:user_id] = Fabricate(:user).id
      comedy = Category.create(name: 'comedy')
      drama = Category.create(name: 'drama')
      get :index
      expect(assigns(:categories)).to include(comedy, drama)
    end

    it "redirects to sign in page for unauthenticated users" do 
      comedy = Category.create(name: 'comedy')
      drama = Category.create(name: 'drama')
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

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
