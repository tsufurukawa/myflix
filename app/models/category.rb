class Category < ActiveRecord::Base
  has_many :videos, -> { order(created_at: :desc) }

  validates :name, presence: true, uniqueness: true

  def recent_videos
    self.videos.first(6)
  end
end