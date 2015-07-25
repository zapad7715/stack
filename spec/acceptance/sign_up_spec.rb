require_relative "acceptance_helper"

feature "User sign-up", %q{
  In order to be able to join to community
  to ask the question
  As an User
  I want to be able to sign up
} do
  given(:user) { create :user }

  scenario "Non-registered user tries to sign up" do
    visit new_user_registration_path

    fill_in "Email", with: "unregistered_user@test.com"
    fill_in "Password", with: "user_password"
    fill_in "Password confirmation", with: "user_password"
    click_on "Sign up"

    expect(page).to have_content("Welcome! You have signed up successfully.")
    expect(current_path).to eq root_path
  end

  scenario "Registered user tries to sign up" do
    visit new_user_registration_path

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password
    click_on "Sign up"

    expect(page).to have_content("Email has already been taken")
  end
end