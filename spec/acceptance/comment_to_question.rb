require 'acceptance/acceptance_helper.rb'

feature 'Add comment to question' do
  given(:user) {create(:user)}
  given!(:question) {create(:question)}
  scenario "Authenticated user can add comment to question", js: true do 
    sign_in(user)
    visit question_path(question)
    
    within ".question" do 
      click_on "Add comment"
      fill_in "Comment", with: "Comment to question"
      click_on 'Create'
      
      expect(page).to have_content "Comment to question"
    end
  end
  
  scenario "Non-authenticated user not sees link add comment to question" do
    visit question_path(question)
    within ".question" do
      expect(page).to_not have_link "Add comment"
    end
  end
end 
