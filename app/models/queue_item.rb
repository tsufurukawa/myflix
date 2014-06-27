class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review.rating if review
  end

  # creates a 'rating' Virtual Attribute
  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(rating: new_rating, video: video, user: user)
      review.save(validate: false) # bypass validation
    end
  end

  def category_name
    category.name
  end

  private 

  def review
    @review ||= Review.find_by(user_id: user.id, video_id: video.id)
  end
end