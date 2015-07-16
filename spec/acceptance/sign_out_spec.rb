require 'rails_helper'

feature 'Registered user is able to log out', %q{
  In order to be able to lieve to community
  to ask the question
  As an User
  I want to be able to sign out
  } do
  given(:user) { create(:user) }

  scenario 'Regisered user tries to log out' do
  	sign_in(user)
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

end