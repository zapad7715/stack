require_relative "acceptance_helper"

feature 'Create answer to question', %q{
  In order create answer to a question
  As an registered user
  I want to be able create answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }
  
  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)      
    end 
    scenario ' create answer', js: true do
      fill_in 'Your answer the question', with: answer.body
      click_on 'Create answer'
    
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content(answer.body)
      end
      expect(page).to have_content "Your answer successfully created."
    end
  
    scenario 'try to create invalid answer', js: true do
      click_on 'Create answer'
    
      expect(page).to have_content "Body is too short (minimum is 3 characters)"
    end
  end
  
  scenario 'Non-registered user tries to create answer' do
    visit question_path(question)
    fill_in 'Your answer the question', with: answer.body
    click_on 'Create answer'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end