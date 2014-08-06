require 'rails_helper'

feature "Admin adds video" do
  scenario "admin successfully adds video and regular user verifies media files were uploaded properly" do
    admin = Fabricate(:admin)
    regular_user = Fabricate(:user)
    category = Fabricate(:category, name: "Comedy")

    sign_in(admin)
    visit new_admin_video_path
    fill_in "Title", with: "Monk"
    select "Comedy", from: "Category"
    fill_in "Description", with: "Detective comedy-drama"
    attach_file "Large Cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small Cover", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "http://www.example.com/some_video.mp4"
    click_button "Add Video"

    sign_out
    sign_in(regular_user)

    find("a[href='/videos/1']").click
    expect(page).to have_selector "img[src='/uploads/test/monk_large.jpg']"
    expect(page).to have_selector "a[href='http://www.example.com/some_video.mp4']"
  end
end