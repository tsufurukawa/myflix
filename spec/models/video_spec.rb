require 'rails_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  
  describe 'search_by_title' do 
    let(:video1) { Fabricate(:video, title: "video1", created_at: 3.minutes.ago) }
    let(:video2) { Fabricate(:video, title: "another video2!!!", created_at: 2.minutes.ago) }

    it "returns empty array if no match" do 
      expect(Video.search_by_title("title")).to eq([])
    end

    it "returns one-video array for one exact match" do 
      expect(Video.search_by_title("video1")).to eq([video1])
    end

    it "returns one-video array for one partial match" do 
      expect(Video.search_by_title("vIDEo2")).to eq([video2])
    end

    it "returns an array of all matches ordered by created_at" do 
      expect(Video.search_by_title("ViDeO")).to eq([video2, video1]) 
    end

    it "returns an empty array for a search with an empty string" do 
      expect(Video.search_by_title("")).to eq([])  
    end
  end

  describe '#average_rating' do 
    let(:video1) { Fabricate(:video) }

    it "returns a float rounded to the nearest tenths place " do 
      review1 = Fabricate(:review, rating: 2, video: video1)
      review2 = Fabricate(:review, rating: 3, video: video1)
      review3 = Fabricate(:review, rating: 3, video: video1)
      expect(video1.average_rating).to eq(2.7)
    end

    it "returns a float with a 0 in the tenths place if average rating is a whole number" do 
      review1 = Fabricate(:review, rating: 4, video: video1)
      review2 = Fabricate(:review, rating: 2, video: video1)
      expect(video1.average_rating).to eql(3.0)
    end

    it "returns nil if there are no reviews/ratings" do 
      expect(video1.average_rating).to be_nil
    end
  end
end