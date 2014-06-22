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
    it "returns the rating from the review if the video associated with the queue item has been reviewed by the user" do 
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: user, video: video, rating: 3)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(3)
    end

    it "returns nil if the video associated with the queue item hasn't been reviewed by the user" do 
      user = Fabricate(:user)
      user2 = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: user2, video: video, rating: 3)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(nil)
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