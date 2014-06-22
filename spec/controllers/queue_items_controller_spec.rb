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

  describe "POST create" do 
    context "for authenticated user" do 
      it "redirects to my_queue page" do 
        session[:user_id] = Fabricate(:user).id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it "creatse a queue item" do 
        session[:user_id] = Fabricate(:user).id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it "creates a queue item associated with the video" do 
        session[:user_id] = Fabricate(:user).id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end 

      it "creates a queue item associated with the signed-in user" do 
        user = Fabricate(:user)
        session[:user_id] = user.id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(user)
      end

      it "puts the video as the last item in the queue" do 
        user = Fabricate(:user)
        session[:user_id] = user.id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item = Fabricate(:queue_item, video: video1, user: user)
        post :create, video_id: video2.id
        new_queue_item = QueueItem.where(user: user, video_id: video2.id).first
        expect(new_queue_item.position).to eq(2)
      end

      it "does not make duplicate queue items" do 
        user = Fabricate(:user)
        session[:user_id] = user.id
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, video: video, user: user)
        post :create, video_id: video.id
        expect(user.queue_items.count).to eq(1)
      end
    end

    context "for unauthenticated users" do 
      it "does not create a queue item" do 
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(0)
      end

      it "redirects to sign-in page" do 
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "DELETE destroy" do 
    context "for authenticated users" do 
      it "reidrects to my queue page" do 
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queue item from the queue" do 
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "does not delete the queue item if the current user does not own the queue item" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        session[:user_id] = user1.id
        queue_item = Fabricate(:queue_item, user: user2)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end

      it "normalizes the remaining queue items" do 
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, user: user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2)
        delete :destroy, id: queue_item1.id
        expect(QueueItem.first.position).to eq(1)
      end
    end

    it "redirects to sign-in page for unauthenticated users" do 
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST update_queue" do 
    context "with valid input" do 
      let(:authenticated_user) { Fabricate(:user) } 
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, position: 1, user: authenticated_user, video: video) } 
      let(:queue_item2) { Fabricate(:queue_item, position: 2, user: authenticated_user, video: video) } 

      before { session[:user_id] = authenticated_user.id } 
 
      it "redirects back to my queue page" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "updates the position" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      it "reorders the queue items in ascending order by position" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(authenticated_user.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position number starting from 1 and incrementing by 1" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(authenticated_user.queue_items.map(&:position)).to eq([1,2])
      end
    end

    context "with invalid input" do 
      let(:authenticated_user) { Fabricate(:user) } 
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, position: 1, user: authenticated_user, video: video) } 
      let(:queue_item2) { Fabricate(:queue_item, position: 2, user: authenticated_user, video: video) } 

      before { session[:user_id] = authenticated_user.id } 

      it "redirects to my queue page" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1.5}, {id: queue_item2.id, position: "hello"}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1.5}, {id: queue_item2.id, position: "hello"}]
        expect(flash[:danger]).to be_present
      end

      it "does not change the queue items" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: "hello"}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "for unauthenticated users" do 
      it "redirects to sign-in page" do 
        post :update_queue, queue_items: [{id: 1, position: 2}, {id: 2, position: 1}]
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with queue items that do not belong to the current user" do 
      it "does not change the queue items" do 
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        session[:user_id] = user1.id
        queue_item1 = Fabricate(:queue_item, position: 3, user: user2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}]
        expect(queue_item1.reload.position).to eq(3)
      end
    end
  end
end