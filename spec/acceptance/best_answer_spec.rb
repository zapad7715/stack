require_relative 'acceptance_helper'

feature 'Best answer', %q{
  In order to mark best solution
  As an author of question
  I want to be able to mark best answer
} do 
    
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:best_answer) { create(:answer, question: question, user: user, best: true) }
  given!(:answer) { create(:answer, question: question) } 
    
  describe 'Authenticated user' do
    context 'non-author of question' do
      before do
        sign_in(user)
        visit question_path(question)
      end
      scenario 'can not marks best answer' do
        expect(page).to_not have_link "Mark as best"
        expect(page).to have_content answer.body
      end
      scenario 'sees best answer' do
        within "#answer-#{best_answer.id}" do
          expect(page).to_not have_link 'Mark as best'
          expect(page).to have_content 'Best answer:'
          expect(page).to have_content best_answer.body
        end
      end
      scenario "sees sorted answers", js: true do
        within '.answers' do
          answers_on_page = page.all('div')
          expect(answers_on_page[0]).to have_content best_answer.body
          expect(answers_on_page[1]).to have_content answer.body
        end
      end
    end
    
    context 'as author' do
      before do
        sign_in(author)
        visit question_path(question)
      end
      scenario 'sees link to mark best answer', js: true do
        within "#answer-#{answer.id}" do
          expect(page).to have_link 'Mark as best'
        end
      end
      scenario 'sees best answer' do
        within "#answer-#{best_answer.id}" do
          expect(page).to_not have_link 'Mark as best'
          expect(page).to have_content 'Best answer:'
          expect(page).to have_content best_answer.body
        end
      end
      scenario "marks best answer", js: true do
        within "#answer-#{answer.id}" do
         click_on('Mark as best')
         
         expect(page).to have_content 'Best answer:'
         expect(page).to have_content answer.body
        end
      end
      
      scenario "sees sorted answers", js: true do
        within '.answers' do
          answers_on_page = page.all('div')
          expect(answers_on_page[0]).to have_content best_answer.body
          expect(answers_on_page[1]).to have_content answer.body
        end
        within "#answer-#{answer.id}" do
         click_on('Mark as best')
         
         expect(page).to have_content 'Best answer:'
         expect(page).to have_content answer.body
        end
        within '.answers' do
          answers_on_page = page.all('div')
          expect(answers_on_page[0]).to have_content answer.body
          expect(answers_on_page[1]).to have_content best_answer.body
        end
      end
      
      scenario "marks only one best answer", js: true do
        within "#answer-#{answer.id}" do
          expect(page).to have_link 'Mark as best'
        end
        within "#answer-#{best_answer.id}" do
          expect(page).to have_content 'Best answer:'
          expect(page).to_not have_link 'Mark as best'
        end
        
        within "#answer-#{answer.id}" do
          click_on 'Mark as best'
          
          expect(page).to_not have_link 'Mark as best'
          expect(page).to have_content 'Best answer:'
          expect(page).to have_content answer.body
        end
        within "#answer-#{best_answer.id}" do
          expect(page).to have_link 'Mark as best'
          expect(page).to_not have_content 'Best answer:'
          expect(page).to have_content best_answer.body
        end
      end
    end
  end
  
  describe 'Unathenticated user' do
    before do
      visit question_path(question)      
    end
    scenario 'tries to choose best answer' do
      expect(page).to_not have_link "Mark as best"
    end
    scenario 'sees best answer' do
      within "#answer-#{best_answer.id}" do
        expect(page).to_not have_link 'Mark as best'
        expect(page).to have_content 'Best answer:'
        expect(page).to have_content best_answer.body
      end
    end
    scenario "sees sorted answers", js: true do
      within '.answers' do
        answers_on_page = page.all('div')
        expect(answers_on_page[0]).to have_content best_answer.body
        expect(answers_on_page[1]).to have_content answer.body
      end
    end    
  end

end