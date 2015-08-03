require_relative "acceptance_helper"

feature 'User can edit question', %q{
  In order to ask question
  As an author of question
  I'd like ot be able to edit my question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  
  scenario 'Unauthenticated user try to edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit my question'
  end
  
  describe 'Authenticated user' do
    scenario "try to edit other user's question", js: true do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit my question'
      end
    end
    
    context 'as author' do
      before  do
        sign_in author
        visit question_path(question)      
      end
      scenario 'sees link to edit his question', js: true do
        within '.question' do
          expect(page).to have_link 'Edit my question'
        end
      end
      scenario 'try to edit his question', js: true do
        click_on 'Edit my question'
        within '.question' do
          fill_in 'Title', with: 'Edited title'
          fill_in 'Body', with: 'Edited body'
          click_on 'Save'
        
          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.body
          expect(page).to have_content 'Edited title'
          expect(page).to have_content 'Edited body'
          expect(page).to_not have_selector 'textarea'
        end
      end 
    end
      
  end
end