require 'rails_helper'

feature "User invites a friend" do
  scenario "user sends invitation and invitation is accepted" do
    user = Fabricate(:user)
    sign_in(user)
    clear_emails

    fill_and_send_out_invitation_form
    sign_out

    friend_accepts_invitation
    expect_email_field_to_be_prepopulated
    friend_signs_up
    open_welcome_email

    friend_should_follow_inviter(user)
    sign_out
    inviter_should_follow_friend(user)

    clear_emails
  end

  def fill_and_send_out_invitation_form
    click_link "Invite a Friend"
    fill_in "Friend's Name", with: "Joe Example"
    fill_in "Friend's Email Address", with: "joe@example.com"
    fill_in "Invitation Message", with: "Join MyFlix!!!"
    click_button "Send Invitation"
  end

  def friend_accepts_invitation
    open_email("joe@example.com")
    current_email.click_link "Accept Invitation"
  end

  def expect_email_field_to_be_prepopulated
    expect(find_field("Email Address").value).to eq("joe@example.com")
  end

  def friend_signs_up
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Joe Example"
    click_button "Sign Up"
    expect(page).to have_content "Welcome Joe Example!! You successfully registered."
  end

  def open_welcome_email
    open_email("joe@example.com")
    expect(current_email).to have_content "Joe Example"
  end

  def friend_should_follow_inviter(inviter)
    click_link "People"
    expect(page).to have_content inviter.name
  end

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content "Joe Example"
  end
end