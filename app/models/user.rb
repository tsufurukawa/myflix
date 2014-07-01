class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order :position }

  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_user_id

  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 5 }
  validates :email, presence: true, uniqueness: true

  def new_queue_item_position
    queue_items.count + 1
  end

  def queued_video_already_exists?(video)
    queue_items.find_by(video: video)
  end

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index| 
      queue_item.update_attributes(position: index + 1)
    end
  end

  def video_in_queue?(video)
    !!queue_items.find_by(video: video)
  end
end