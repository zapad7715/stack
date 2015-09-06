require_relative "acceptance_helper"

feature 'Add files to question' do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
  
    before do
      sign_in(user)
      visit new_question_path
    
      fill_in 'Title', with: 'Test question' 
      fill_in 'Body', with: 'text text'    
    end
  
    scenario 'adds file when ask question' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create'
    
      expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/1/spec_helper.rb"    
    end
    scenario 'adds many files when ask question', js: true do
      click_on "Add file"
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    
      click_on "Create"
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/2/spec_helper.rb"
      expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/3/rails_helper.rb"
    end
  end
  
  describe 'Non-authenticated user' do
    scenario 'tris add file when ask question' do
      visit new_question_path
      expect(page).to_not have_link "Add file"
    end
  end
end