require 'rails_helper'

describe Relationship do 
  it { should belong_to(:followed) }
  it { should belong_to(:follower) }
  it { should validate_uniqueness_of(:follower_user_id).scoped_to(:followed_user_id) }
end