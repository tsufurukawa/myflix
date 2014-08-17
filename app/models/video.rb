class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }

  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    self.where("upper(title) LIKE upper(?)", "%#{search_term}%").order(created_at: :desc)  
  end
end