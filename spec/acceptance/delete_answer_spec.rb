require 'rails_helper'

feature 'Registered user deletes answer', %q{
  Author can delete his own answers
  As an registered user
  I want delete my answer
} do
  given(:author) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: author) }

  scenario 'Author is able to delete his own answer' do
    sign_in(author)
    visit question_path(answer.question)
    click_on 'Delete my answer'
    
    expect(page).to have_content 'Your answer successfully deleted.'
    expect(page).to_not have_content answer.body
  end

  scenario 'Registered user tries to delete an answer of another user' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_content 'Delete my answer'
  end

  scenario "Non-authenticated user can not delete answer" do
    visit question_path(question)
    expect(page).to_not have_content 'Delete my answer'
  end
end