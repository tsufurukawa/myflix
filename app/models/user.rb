class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order :position }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_user_id
  has_many :followed_relationships, class_name: "Relationship", foreign_key: :followed_user_id

  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 5 }
  validates :email, presence: true, uniqueness: true

  before_create :generate_token

  def new_queue_item_position
    queue_items.count + 1
  end

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index| 
      queue_item.update_attributes(position: index + 1)
    end
  end

  def video_already_queued?(video)
    !!queue_items.find_by(video: video)
  end

  def already_following?(followed_user)
    !!following_relationships.find_by(followed: followed_user)
  end

  def can_follow?(another_user)
    !(already_following?(another_user) || self == another_user) 
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end