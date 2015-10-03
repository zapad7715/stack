require_relative "acceptance_helper"

feature 'User sing in with Facebook' do
  background { OmniAuth.config.test_mode = true }
  given!(:registered_user) { create(:user) }

  scenario 'Registered user sign in via Facebook' do
    visit new_user_session_path
    omni_auth :facebook, registered_user.email
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from facebook account.'
  end
end