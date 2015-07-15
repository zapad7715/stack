require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer_of_author) { create(:answer, user: author) }
  describe 'POST #create' do
    sign_in_user
    context 'with valid parameters' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }.to \
        change(question.answers, :count).by(1)
      end
      it 'redirects to question\'s show view' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:question))
      end
      it 'assign an answer to the author' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(assigns(:answer).user_id).to eq @user.id
      end
    end
    context 'with invalid parameters' do
      it 'does not save the answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer) }.to_not \
        change(Answer, :count)
      end
      it 're-renders question\'s show view' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer)
        expect(response).to render_template 'questions/show'
      end
    end
  end
  
  describe 'DELETE #destroy' do
    context 'Author delete answer' do
      it 'author tries to delete answer' do
        sign_in(author)
        answer_of_author
        expect{ delete :destroy, id: answer_of_author }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question path' do
        sign_in(author)
        answer_of_author   
        delete :destroy, id: answer_of_author 
        expect(response).to redirect_to question_path(answer_of_author.question_id) 
      end
    end
   
    context 'Another user tries delete answer' do
      it 'not the author tries delete answer' do
        sign_in(another_user)
        answer_of_author
        expect{ delete :destroy, id: answer_of_author }.to_not change(Answer, :count)
      end

      it 'redirect to question path' do
        sign_in(another_user)
        delete :destroy, id: answer_of_author 
        expect(response).to redirect_to question_path(answer_of_author.question_id) 
      end
    end
  end
end
