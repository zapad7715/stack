require_relative "acceptance_helper"

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'Your answer the question', with: 'My answer' 
    end
  
    scenario 'User adds file when create answer', js: true do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb', href: "/uploads/attachment/file/1/rails_helper.rb"    
      end
    end
  
    scenario 'User add many files to answer', js: true do
      click_on "Add file"
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    
      click_on "Create"
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
      expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/2/rails_helper.rb"
    end
  end
  describe 'Non-authenticated user' do
    scenario 'tris add file to answer' do
      visit question_path(question)
      expect(page).to_not have_link "Add file"
    end
  end
end