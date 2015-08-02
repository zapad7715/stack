require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:author) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:question) { create(:question) }
  let(:answer_of_author) { create(:answer, user: author) }
  describe 'POST #create' do
    sign_in_user
    context 'with valid parameters' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.to \
        change(question.answers, :count).by(1)
      end
      it 'render create template' do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
      it 'assign an answer to the author' do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer).user_id).to eq @user.id
      end
    end
    context 'with invalid parameters' do
      it 'does not save the answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }.to_not \
        change(Answer, :count)
      end
      it 're-render create template' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end
  
  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question, user: author) }
    before do 
      sign_in author
    end
    context 'valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end
      it 'assigns the question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end
      it 'changes answer attributes' do
        patch :update, id: answer, question_id: question, answer: {body: 'new body'}, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end
      it 'render update template' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end
  end
  
  describe 'POST #best' do
    let!(:question) { create(:question, user: author) }
    let!(:answer) { create(:answer, question: question) }    
    context "Author of question select best answer" do
      before do
        sign_in(author)
        post :best, question_id: question, id: answer, format: :js
      end
      
      it "answer is marked as best answer" do
        expect(answer.reload.best).to be true
      end
      it 'renders template for best answer' do
        expect(response).to render_template :best
      end
    end

    context "non-onwer select best answer" do
      before do
        sign_in(another_user)
        post :best, question_id: question, id: answer, format: :js
      end

      it "answer is not marked as best answer" do
        expect(answer.reload.best).to be false
      end
    end
  end
  
  describe 'DELETE #destroy' do
    context 'Author delete answer' do
      it 'author tries to delete answer' do
        sign_in(author)
        answer_of_author
        expect{ delete :destroy, id: answer_of_author, format: :js }.to change(answer_of_author.question.answers, :count).by(-1)
      end

      it 'render template destroy' do
        sign_in(author)
        answer_of_author   
        delete :destroy, id: answer_of_author, format: :js 
        expect(response).to render_template :destroy 
      end
    end
   
    context 'Another user tries delete answer' do
      it 'not the author tries delete answer' do
        sign_in(another_user)
        answer_of_author
        expect{ delete :destroy, id: answer_of_author, format: :js }.to_not change(answer_of_author.question.answers, :count)
      end
    end
  end
end
