class GenerateTokenForExistingUsers < ActiveRecord::Migration
  def change
    User.all.each do |user|
      # update_column bypasses validations
      user.update_column(:token, SecureRandom.urlsafe_base64)
    end
  end
end
