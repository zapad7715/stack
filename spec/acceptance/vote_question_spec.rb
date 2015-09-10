require_relative 'acceptance_helper'

feature 'Vote for the question' do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:vote) { create(:vote, votable: question, user: user) }

  scenario 'Author question try to voting' do
    sign_in author
    visit question_path(question)

    expect(page).to_not have_link '+'
    expect(page).to_not have_link '-'
    expect(page).to_not have_link 'x'
  end

  describe 'Another authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'have link for voting' do
      within "#question-vote-#{question.id}" do
        expect(page).to have_link '+'
        expect(page).to have_link '-'
      end
    end

    scenario 'voting up for question', js: true do
      within "#question-vote-#{question.id}" do
        click_on '+'

        expect(page).to have_content '1'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_link 'x'
      end
    end

    scenario 'voting down for question', js: true do
      within "#question-vote-#{question.id}" do
        click_link '-'

        expect(page).to have_content '-1'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_link 'x'
      end
    end

    scenario 'cancel vote for question', js: true do
      vote
      visit question_path(question)

      within "#question-vote-#{question.id}" do
        click_link 'x'

        expect(page).to have_content '0'
        expect(page).to have_link '+'
        expect(page).to have_link '-'
        expect(page).to_not have_link 'x'
      end
    end
  end

  scenario 'non-authenticated user try to voting' do
    visit question_path(question)

    expect(page).to_not have_link '+'
    expect(page).to_not have_link '-'
    expect(page).to_not have_link 'x'
  end
end