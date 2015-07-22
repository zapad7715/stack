require 'rails_helper'

feature 'Create answer to question', %q{
  In order create answer to a question
  As an registered user
  I want to be able create answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }
  scenario 'Registered user create answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your answer the question', with: answer.body
    click_on 'Create answer'
    
    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content(answer.body)
    end
  end
  
  scenario 'Non-registered user tries to create answer' do
    visit question_path(question)
    fill_in 'Your answer the question', with: answer.body
    click_on 'Create answer'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
end