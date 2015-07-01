require 'rails_helper'

feature 'View question and answers to it', %q{
  In order to find answers to the question
  As an user
  I want to see all the answers to the question
} do
  scenario "The all users can view the question and answers to it" do
    question = create(:question)
    question.answers = create_list(:answer, 5)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each do |qa|
      expect(page).to have_content(qa.body)
    end
  end

end