require 'rails_helper'

feature "User following" do 
  scenario "user follows and unfollows another user" do 
    comedy = Fabricate(:category, name: "comedy")
    monk = Fabricate(:video, title: "Monk", category: comedy)
    alice = Fabricate(:user, name: "Alice")
    bob = Fabricate(:user, name: "Bob")
    review = Fabricate(:review, user: alice, video: monk)
    
    sign_in(bob)
    click_on_video_on_home_page(monk)

    click_on_user_link(alice)
    expect_user_profile_page(alice)    

    click_link "Follow"
    expect_user_in_people_page(alice)

    click_on_user_link(alice)
    expect_link_not_to_be_seen("Follow")

    visit_people_page
    unfollow(alice)
    expect_link_not_to_be_seen("Alice")
  end

  def click_on_user_link(user)
    click_link user.name
  end

  def expect_user_profile_page(user)
    expect(page).to have_content("#{user.name}'s video collections")    
  end

  def expect_user_in_people_page(followed_user)
    expect(page).to have_content(followed_user.name)  
  end

  def visit_people_page
    click_link "People"
  end

  def unfollow(followed_user)
    find("a[href='/relationships/#{followed_user.followed_relationships.first.id}']").click
  end
end