require 'acceptance/acceptance_helper.rb'

feature 'Add comment to answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  scenario "Authenticated user can add comment to answer", js: true do 
    sign_in(user)
    visit question_path(question)
    
    within ".answers" do 
      click_on "Add comment"
      fill_in "Comment", with: "Comment to answer"
      click_on 'Create'
      
      expect(page).to have_content "Comment to answer"
    end
  end
  
  scenario "Non-authenticated user not sees link add comment to answer" do
    visit question_path(question)
    within ".answers" do
      expect(page).to_not have_link "Add comment"
    end
  end
end 
