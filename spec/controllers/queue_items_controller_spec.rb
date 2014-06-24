require 'rails_helper' 

describe QueueItemsController do 
  describe "GET index" do 
    let(:action) { get :index }

    it "sets the @queue_items variable for authenticated users" do
      sets_current_user
      authenticated_user = current_user
      queue_item1 = Fabricate(:queue_item, user: authenticated_user)
      queue_item2 = Fabricate(:queue_item, user: authenticated_user)  
      action
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    
    it_behaves_like "require_sign_in"
  end

  describe "POST create" do 
    let(:video) { Fabricate(:video) }
    before { sets_current_user }

    context "for authenticated user" do 
      it "redirects to my_queue page" do 
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it "creatse a queue item" do 
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it "creates a queue item associated with the video" do 
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end 

      it "creates a queue item associated with the signed-in user" do 
        user = current_user
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(user)
      end

      it "puts the video as the last item in the queue" do 
        user = current_user
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item = Fabricate(:queue_item, video: video1, user: user)
        post :create, video_id: video2.id
        new_queue_item = QueueItem.where(user: user, video_id: video2.id).first
        expect(new_queue_item.position).to eq(2)
      end

      it "does not make duplicate queue items" do 
        user = current_user
        queue_item = Fabricate(:queue_item, video: video, user: user)
        post :create, video_id: video.id
        expect(user.queue_items.count).to eq(1)
      end
    end

    context "for unauthenticated users" do 
      let(:video) { Fabricate(:video) }
      before { clear_current_user }

      it "does not create a queue item" do 
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(0)
      end

      it_behaves_like "require_sign_in" do 
        let(:action) { post :create, video_id: video.id }
      end
    end
  end

  describe "DELETE destroy" do 
    context "for authenticated users" do 
      before { sets_current_user } 

      it "reidrects to my queue page" do 
        user = current_user
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queue item from the queue" do 
        user = current_user
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
        user = current_user
        queue_item1 = Fabricate(:queue_item, user: user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: user, position: 2)
        delete :destroy, id: queue_item1.id
        expect(QueueItem.first.position).to eq(1)
      end
    end

    it_behaves_like "require_sign_in" do 
      let(:action) do 
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
      end
    end
  end

  describe "PATCH update_queue" do 
    before { sets_current_user }
    
    context "with valid input" do 
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, position: 1, user: current_user, video: video) } 
      let(:queue_item2) { Fabricate(:queue_item, position: 2, user: current_user, video: video) } 
 
      it "redirects back to my queue page" do 
        patch :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "updates the position" do
        patch :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      it "reorders the queue items in ascending order by position" do 
        patch :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(current_user.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position number starting from 1 and incrementing by 1" do 
        patch :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(current_user.queue_items.map(&:position)).to eq([1,2])
      end
    end

    context "with invalid input" do 
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, position: 1, user: current_user, video: video) } 
      let(:queue_item2) { Fabricate(:queue_item, position: 2, user: current_user, video: video) } 

      it "redirects to my queue page" do 
        patch :update_queue, queue_items: [{id: queue_item1.id, position: 1.5}, {id: queue_item2.id, position: "hello"}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do 
        patch :update_queue, queue_items: [{id: queue_item1.id, position: 1.5}, {id: queue_item2.id, position: "hello"}]
        expect(flash[:danger]).to be_present
      end

      it "does not change the queue items" do 
        patch :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: "hello"}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with queue items that do not belong to the current user" do 
      it "does not change the queue items" do 
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        session[:user_id] = user1.id
        queue_item1 = Fabricate(:queue_item, position: 3, user: user2)
        patch :update_queue, queue_items: [{id: queue_item1.id, position: 2}]
        expect(queue_item1.reload.position).to eq(3)
      end
    end

    it_behaves_like "require_sign_in" do 
      let(:action) { patch :update_queue, queue_items: [{id: 1, position: 2}, {id: 2, position: 1}] }
    end
  end
end