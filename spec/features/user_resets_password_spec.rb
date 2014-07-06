require 'rails_helper'

feature "User resets password" do
  scenario "user forgets and resets password" do
    user = Fabricate(:user, name: "Joe Smith", email: "test@example.com", password: "password")
    clear_emails

    visit sign_in_path
    click_link "Forgot Password?" 

    fill_in "Email Address", with: user.email
    click_button "Send Email"

    open_email(user.email)
    current_email.click_link "Reset Password"

    fill_in "New Password", with: "new password"
    click_button "Reset Password"

    fill_in "Email Address", with: user.email
    fill_in "Password", with: "new password"
    click_button "Sign in"
    expect(page).to have_content("Welcome #{user.name}!! You successfully signed in.")
  end
end