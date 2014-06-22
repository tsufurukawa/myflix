class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.find_by(user_id: user.id, video_id: video.id)
    review.rating if review
  end

  def category_name
    category.name
  end
end