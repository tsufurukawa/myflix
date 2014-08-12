require 'rails_helper'

feature "User registers and makes payment", { js: true, vcr: true } do
  background do
    visit register_path
  end

  scenario "with valid personal info and valid card" do
    register_and_pay_with_credit_card(name: "Joe Example", card_number: "4242424242424242")
    expect(page).to have_content "Welcome Joe Example!! You successfully registered."
  end

  scenario "with valid personal info and invalid card" do
    register_and_pay_with_credit_card(name: "Joe Example", card_number: "123")
    expect(page).to have_content "This card number looks invalid"
  end

  scenario "with valid personal info and declined card" do
    register_and_pay_with_credit_card(name: "Joe Example", card_number: "4000000000000002")
    expect(page).to have_content "Your card was declined."
  end

  scenario "with invalid personal info and valid card" do
    register_and_pay_with_credit_card(name: nil, card_number: "4242424242424242")
    expect(page).to have_content "Please fix the error(s) below."
  end

  scenario "with invalid personal info and invalid card" do
    register_and_pay_with_credit_card(name: nil, card_number: "123")
    expect(page).to have_content "This card number looks invalid"
  end

  scenario "with invalid personal info and declined card" do
    register_and_pay_with_credit_card(name: nil, card_number: "4000000000000002")
    expect(page).to have_content "Please fix the error(s) below."
  end
end

def register_and_pay_with_credit_card(options={})
  fill_in "Email Address", with: "joe@example.com"
  fill_in "Password", with: "password"
  fill_in "Full Name", with: options[:name]
  fill_in "Credit Card Number", with: options[:card_number]
  fill_in "Security Code", with: "123"
  select('8 - August', from: 'card-expiry-month')
  select('2018', from: 'card-expiry-year')
  click_button "Sign Up for $9.99!!"
end