require 'rails_helper'

describe Invitation do
  it { should belong_to(:inviter).class_name("User") }
  it { should validate_presence_of(:recipient_name) }
  it { should validate_presence_of(:recipient_email) }
  it { should validate_presence_of(:message) }
end