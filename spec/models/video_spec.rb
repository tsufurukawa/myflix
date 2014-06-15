require 'rails_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  
  describe 'search_by_title' do 
    it "returns empty array if no match" do 
      video1 = Video.create(title: "video1", description: "some description")
      video2 = Video.create(title: "another video2", description: "another description")
      expect(Video.search_by_title("title")).to eq([])
    end

    it "returns one-video array for one exact match" do 
      video1 = Video.create(title: "video1", description: "some description")
      video2 = Video.create(title: "another video2", description: "another description")
      expect(Video.search_by_title("video1")).to eq([video1])
    end

    it "returns one-video array for one partial match" do 
      video1 = Video.create(title: "video1", description: "some description")
      video2 = Video.create(title: "another video2!!!", description: "another description")
      expect(Video.search_by_title("vIDEo2")).to eq([video2])
    end

    it "returns an array of all matches ordered by created_at" do 
      video1 = Video.create(title: "video1", description: "some description", created_at: 3.minutes.ago)
      video2 = Video.create(title: "another video2!!!", description: "another description", created_at: 2.minutes.ago)
      expect(Video.search_by_title("ViDeO")).to eq([video2, video1]) 
    end

    it "returns an empty array for a search with an empty string" do 
      video1 = Video.create(title: "video1", description: "some description", created_at: 3.minutes.ago)
      video2 = Video.create(title: "another video2!!!", description: "another description", created_at: 2.minutes.ago)
      expect(Video.search_by_title("")).to eq([])  
    end
  end

  describe '#average_rating' do 
    it "returns a float rounded to the nearest tenths place " do 
      video1 = Fabricate(:video)
      review1 = Fabricate(:review, rating: 2, video: video1)
      review2 = Fabricate(:review, rating: 3, video: video1)
      review3 = Fabricate(:review, rating: 3, video: video1)
      expect(video1.average_rating).to eq(2.7)
    end

    it "returns a float with a 0 in the tenths place if average rating is a whole number" do 
      video1 = Fabricate(:video)
      review1 = Fabricate(:review, rating: 4, video: video1)
      review2 = Fabricate(:review, rating: 2, video: video1)
      expect(video1.average_rating).to eql(3.0)
    end

    it "returns nil if there are no reviews/ratings" do 
      video1 = Fabricate(:video)
      expect(video1.average_rating).to be_nil
    end
  end
end