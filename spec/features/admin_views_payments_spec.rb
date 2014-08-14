require 'rails_helper'

feature "Admin views payments" do
  background do
    alice = Fabricate(:user, name: "Alice", email: "alice@example.com")
    Fabricate(:payment, user: alice, amount: 999)
  end

  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Alice")
    expect(page).to have_content("alice@example.com")
  end

  scenario "regular users cannot see payments" do
    sign_in
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Alice")
    expect(page).to have_content("You are not authorized to do that.")
  end
end