require 'rails_helper'

describe RelationshipsController do 
  describe "GET index" do 
    it "sets the @followings variable to the people the current user is following" do 
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      sets_current_user(user1)
      relationship = Fabricate(:relationship, follower: user1, followed: user2)
      get :index
      expect(assigns(:following_relationships)).to match_array([relationship])
    end

    it_behaves_like "require_sign_in" do 
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do 
    context "for authenticated users" do 
      it "redirects to the people page" do 
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        sets_current_user(user1)
        relationship = Fabricate(:relationship, follower: user1, followed: user2)
        delete :destroy, id: relationship.id
        expect(response).to redirect_to people_path
      end

      it "destroys the relationship if the current user is the follower" do 
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        sets_current_user(user1)
        relationship = Fabricate(:relationship, follower: user1, followed: user2)
        delete :destroy, id: relationship.id
        expect(Relationship.count).to eq(0)
      end

      it "doesn't destroy the relationship if the current user is not the follower" do 
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        user3 = Fabricate(:user)
        sets_current_user(user1)
        relationship = Fabricate(:relationship, follower: user3, followed: user2)
        delete :destroy, id: relationship.id
        expect(Relationship.count).to eq(1)
      end
    end

    it_behaves_like "require_sign_in" do 
      let(:action) { delete :destroy, id: 1 }
    end
  end
end