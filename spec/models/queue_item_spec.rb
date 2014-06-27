require 'rails_helper'

describe QueueItem do 
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:position) }
  it { should validate_numericality_of(:position).only_integer }
  it { should validate_numericality_of(:position).is_greater_than_or_equal_to(0)}

  describe "#video_title" do 
    it "returns the title of the associated video" do 
      video = Fabricate(:video, title: "Futurama")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Futurama")
    end 
  end

  describe "#rating" do 
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, video: video, user: user) }

    it "returns the rating from the review if the video associated with the queue item has been reviewed by the user" do 
      review = Fabricate(:review, user: user, video: video, rating: 3)
      expect(queue_item.rating).to eq(3)
    end

    it "returns nil if the video associated with the queue item hasn't been reviewed by the user" do 
      user2 = Fabricate(:user)
      review = Fabricate(:review, user: user2, video: video, rating: 3)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#rating=" do 
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, user: user, video: video) }
    let(:review) { Fabricate(:review, user: user, rating: 1, video: video) }

    it "updates the rating if the review already exists" do 
      queue_item.rating = 3
      expect(Review.first.rating).to eq(3)
    end

    it "removes the rating if the review already exists" do 
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end

    it "creates a new review with the rating if the review does not exist" do 
      queue_item.rating = 3
      expect(Review.first.rating).to eq(3)
    end
  end

  describe "#category_name" do 
    it "returns the category name of the associated video" do 
      category = Fabricate(:category, name: "Comedy")
      video = Fabricate(:video, category: category)      
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Comedy")
    end
  end

  describe "#category" do 
    it "returns the category object associated with the queue item's video" do 
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end