require_relative 'acceptance_helper'

feature 'User can delete files from answer' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: author)}
  given!(:attachment) { create(:attachment, attachable: answer) }
  
  describe 'Authenticated user' do
    scenario 'as author of answer, can delete the files that he stuck to his answer', js: true do
      sign_in(author)
      visit question_path(question)
      within "#answer-attachment-id-#{attachment.id}" do
        expect(page).to have_link 'Delete file'
        expect(page).to have_content attachment.file.file.filename
        
        click_on "Delete file"
      end
      expect(page).to_not have_content attachment.file.file.filename
    end 
    scenario 'as non-author of question, can\'t delete the files to answer', js: true do
      sign_in(user)
      visit question_path(question)
      within "#answer-attachment-id-#{attachment.id}" do
        expect(page).to_not have_link 'Delete file'
        expect(page).to have_content attachment.file.file.filename
      end
    end
  end
  
  describe 'Non-authenticated user' do
    scenario 'as non-author of question, can\'t delete the files to question', js: true do
      visit question_path(question)
      within "#answer-attachment-id-#{attachment.id}" do
        expect(page).to_not have_link 'Delete file'
        expect(page).to have_content attachment.file.file.filename
      end
    end
  end
end
