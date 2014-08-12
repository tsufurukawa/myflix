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
end