require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  describe 'POST #create' do
    context 'with valid parameters' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }.to \
        change(question.answers, :count).by(1)
      end
      it 'redirects to question\'s show view' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:question))
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
end
