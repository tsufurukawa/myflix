# following methods used for unit specs
def sets_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def sets_current_admin(admin=nil)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

# following methods used for feature specs
def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "Email Address", with: user.email 
  fill_in "Password", with: user.password 
  click_button "Sign in" 
end

def sign_out
  visit sign_out_path
end

def click_on_video_on_home_page(video)
  visit home_path
  find("a[href='/videos/#{video.id}']").click
end

def expect_link_not_to_be_seen(link_text)
  expect(page).not_to have_content(link_text)
end