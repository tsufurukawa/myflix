class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    self.where("title LIKE ?", "%#{search_term}%").order(created_at: :desc)  
  end

  def average_rating
    review = Review.where(video: self)
    average = review.average(:rating).round(1) unless review.count == 0
  end
end