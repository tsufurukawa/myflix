require 'rails_helper'

describe Category do 
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  describe '#recent_videos' do 
    let(:comedy) { Category.create(name: "comedy") }

    it "returns all video in the category if less than 6 videos" do 
      video1 = Video.create(title: "hello", description: "hi", category: comedy)
      video2 = Video.create(title: "hello", description: "hi", category: comedy)
      video3 = Video.create(title: "hello", description: "hi", category: comedy)
      expect(comedy.recent_videos.count).to eq(3)
    end

    it "returns videos in the category ordered by created_at reverse-chronologically" do
      video1 = Video.create(title: "hello", description: "hi", category: comedy)
      video2 = Video.create(title: "hello", description: "hi", category: comedy, created_at: 3.minutes.ago)
      video3 = Video.create(title: "hello", description: "hi", category: comedy, created_at: 2.minutes.ago)
      expect(comedy.recent_videos).to eq([video1, video3, video2])
    end

    it "returns 6 most recent videos if more than 6 videos in category" do 
      video1 = Video.create(title: "hello", description: "hi", category: comedy, created_at: 2.minutes.ago)
      video2 = Video.create(title: "hello", description: "hi", category: comedy, created_at: 5.minutes.ago)
      video3 = Video.create(title: "hello", description: "hi", category: comedy, created_at: 10.minutes.ago)
      video4 = Video.create(title: "hello", description: "hi", category: comedy, created_at: 3.minutes.ago)
      video5 = Video.create(title: "hello", description: "hi", category: comedy, created_at: 6.minutes.ago)
      video6 = Video.create(title: "hello", description: "hi", category: comedy, created_at: 1.minutes.ago)
      video7 = Video.create(title: "hello", description: "hi", category: comedy, created_at: 4.minutes.ago)
      video8 = Video.create(title: "hello", description: "hi", category: comedy, created_at: 8.minutes.ago)
      expect(comedy.recent_videos).to eq([video6, video1, video4, video7, video2, video5])
    end

    it "returns empty array if no videos in the category" do 
      expect(comedy.recent_videos).to eq([])
    end
  end
end