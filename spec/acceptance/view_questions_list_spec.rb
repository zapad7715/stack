require 'rails_helper'

feature 'All users can view the questions' do

  scenario 'All users are able to view all the questions' do
    questions = create_list(:question, 5)
    visit questions_path
    questions.each do |question|
      expect(page).to have_link question.title
    end
  end
end