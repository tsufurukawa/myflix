require 'rails_helper'

describe VideoDecorator do
  describe "#rating" do
    it "averages the video's ratings to the nearest tenths place and returns the string 'Rating: rating/5.0'" do
      video1 = Fabricate(:video).decorate
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      user3 = Fabricate(:user)
      review1 = Fabricate(:review, rating: 1, video: video1, user: user1)
      review2 = Fabricate(:review, rating: 3, video: video1, user: user2)
      review3 = Fabricate(:review, rating: 3, video: video1, user: user3)
      expect(video1.rating).to eq("Rating: 2.3/5.0")
    end

    it "returns the string 'Not Yet Rated' if video has no reviews" do
      video1 = Fabricate(:video).decorate
      expect(video1.rating).to eq("Not Yet Rated")
    end
  end
end