class Relationship < ActiveRecord::Base
  belongs_to :followed, class_name: "User", foreign_key: :followed_user_id
  belongs_to :follower, class_name: "User", foreign_key: :follower_user_id

  validates_uniqueness_of :follower_user_id, scope: :followed_user_id
end