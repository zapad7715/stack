require_relative 'acceptance_helper'

feature 'Vote for the answer' do

  given(:author) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given(:vote) { create(:vote, votable: answer, user: another_user) }

  scenario 'Author answer try to voting' do
    sign_in author
    visit question_path(question)

    expect(page).to_not have_link '+'
    expect(page).to_not have_link '-'
    expect(page).to_not have_link 'x'
  end

  describe 'Another authenticated user' do
    before do
      sign_in another_user
      visit question_path(question)
    end

    scenario 'have link for voting' do
      within "#answer-vote-#{answer.id}" do
        expect(page).to have_link '+'
        expect(page).to have_link '-'
      end
    end

    scenario 'voting up for answer', js: true do
      within "#answer-vote-#{answer.id}" do
        click_on '+'

        expect(page).to have_content '1'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_link 'x'
      end
    end

    scenario 'voting down for answer', js: true do
      within "#answer-vote-#{answer.id}" do
        click_link '-'

        expect(page).to have_content '-1'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_link 'x'
      end
    end

    scenario 'cancel vote for answer', js: true do
      vote
      visit question_path(question)

      within "#answer-vote-#{answer.id}" do
        click_link 'x'

        expect(page).to have_content '0'
        expect(page).to have_link '+'
        expect(page).to have_link '-'
        expect(page).to_not have_link 'x'
      end
    end
  end

  scenario 'Non-authenticated user try to voting' do
    visit question_path(question)

    expect(page).to_not have_link '+'
    expect(page).to_not have_link '-'
    expect(page).to_not have_link 'x'
  end
end