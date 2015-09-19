require_relative "acceptance_helper"

feature 'Registered user can delete questions', %q{
  In order to delete question
  As an author
  I want to delete question
} do
  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: first_user) }
  scenario 'Author tries to delete question' do
    sign_in(first_user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully destroyed.'
    expect(page).to_not have_content question.title
    expect(current_path).to eq questions_path
  end
  
  scenario 'Registered user tries to delete a foreign question' do
    sign_in(second_user)
    visit question_path(question)
    
    expect(page).to_not have_link 'Delete question'
  end
  
  scenario 'Non-registered user tries to delete question' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end
end