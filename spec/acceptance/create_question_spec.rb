require_relative "acceptance_helper"

feature 'Create question', %q{
	In order to be able to ask question
	As an registered user
	I want to be able to create question
} do 
  given(:user) { create(:user) }
  scenario 'Registered user creates question' do
    sign_in(user)
    
    visit questions_path
    click_on 'Ask question'
    
    expect(current_path).to eq new_question_path
    
    fill_in 'Title', with: 'Test question' 
    fill_in 'Body', with: 'text text'
    click_on 'Create'
    
    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text'
  end

  scenario 'Non-registered user tries to create question' do
    visit questions_path
    click_on 'Ask question'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
	
end 
