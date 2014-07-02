require 'rails_helper'

describe User do 
  it { should have_secure_password }
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:following_relationships) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:email) }
  it { should ensure_length_of(:password).is_at_least(5) }

  describe "#video_already_queued?" do 
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it "returns true when video is already in queue" do 
      Fabricate(:queue_item, user: user, video: video)
      expect(user.video_already_queued?(video)).to eq(true)
    end

    it "returns false when video is not already in queue" do 
      expect(user.video_already_queued?(video)).to eq(false)
    end
  end

  describe "#already_following?" do 
    let(:user1) { Fabricate(:user) }
    let(:user2) { Fabricate(:user) }

    it "returns true if user has an existing following relationship with another user" do 
      Fabricate(:relationship, follower: user1, followed: user2)
      expect(user1.already_following?(user2)).to eq(true)
    end

    it "returns false if user does not have a following relationship with another user" do 
      Fabricate(:relationship, follower: user2, followed: user1)
      expect(user1.already_following?(user2)).to eq(false)
    end
  end
end