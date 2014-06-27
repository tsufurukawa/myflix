require 'rails_helper'

describe User do 
  it { should have_secure_password }
  it { should have_many(:reviews) }
  it { should have_many(:queue_items).order(:position) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:email) }
  it { should ensure_length_of(:password).is_at_least(5) }

  describe "#video_in_queue?" do 
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it "returns true when video is already in queue" do 
      Fabricate(:queue_item, user: user, video: video)
      expect(user.video_in_queue?(video)).to eq(true)
    end

    it "returns false when video is not already in queue" do 
      expect(user.video_in_queue?(video)).to eq(false)
    end
  end
end