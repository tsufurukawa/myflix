require 'rails_helper'

feature "user signs in" do 
  given(:user) { Fabricate(:user) } 

  scenario "with valid credentials" do 
    sign_in(user)
    expect(page).to have_content(user.name)
  end 
end