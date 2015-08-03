require_relative "acceptance_helper"

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like ot be able to edit my answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }
  
  scenario 'Unauthenticated user try to edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit my answer'
  end
  
  describe 'Authenticated user' do
    scenario "try to edit other user's answer", js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit my answer'
      end
    end  
    
    context 'as author' do
      before  do
        sign_in author
        visit question_path(question)      
      end
      scenario 'sees link to edit his answer', js:true do
        within '.answers' do
          expect(page).to have_link 'Edit my answer'
        end
      end 
      scenario 'try to edit his answer', js: true do
        click_on 'Edit my answer'
        within '.answers' do
          fill_in 'Edit your answer', with: 'edited answer'
          click_on 'Save'
        
          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end    
    end

  end 
end 