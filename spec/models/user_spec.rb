require 'rails_helper'

describe User do 
  it { should have_secure_password }
  it { should have_many(:reviews) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:email) }
  it { should ensure_length_of(:password).is_at_least(5) }
end