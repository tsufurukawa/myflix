require 'rails_helper' 

describe QueueItemsController do 
  describe "GET index" do 
    it "sets the @queue_items variable for authenticated users" do
      authenticated_user = Fabricate(:user)
      queue_item1 = Fabricate(:queue_item, user: authenticated_user)
      queue_item2 = Fabricate(:queue_item, user: authenticated_user)  
      session[:user_id] = authenticated_user.id
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    
    it "redirects to sign-in page for unauthenticated users" do 
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end
end