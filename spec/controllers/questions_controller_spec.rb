require 'rails_helper'

RSpec.describe QuestionsController do
  
  it_should_behave_like "voted"
  
  let(:question) { create(:question) }
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }
    it 'populates an array of all questions' do      
      expect(assigns(:questions)).to match_array(questions) 
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
                                       
  describe 'GET #show' do             
    before { get :show, id: question }
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
  
  describe 'GET #new' do
    sign_in_user
    before { get :new }
    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end
  
  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders new view' do
      expect(response).to render_template :edit
    end
  end
  
  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect{ post :create, question: attributes_for(:question) }.to \
          change(Question, :count).by(1)
      end
      it 'assign a question to the author' do
        post :create, question: attributes_for(:question)
        expect(assigns(:question).user_id).to eq @user.id
      end
      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid attributes' do
      it 'does not save the question' do
        expect{ post :create, question: attributes_for(:invalid_question) }.to_not \
          change(Question, :count)
      end
      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end
  
  describe 'PATCH #update' do
    let!(:author) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:question) { create(:question, user: author) }
    context 'valid attributes' do
      before { sign_in author }
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'render template update' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end
    context 'invalid attributes' do
      before { sign_in author }
      before { patch :update, id: question, question: {title: 'new title', body: nil}, format: :js }
      it 'does not changes question attributes' do
        question.reload
        expect(question.title).to have_content "My string"
        expect(question.body).to have_content "My body"
      end
      it 'renders edit view' do
         expect(response).to render_template :update
      end
    end
    context 'Another user' do
      it 'render status 403' do
        sign_in another_user
        patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
        
        expect(response.status).to eq(403)
      end
    end
  end
  
  describe 'DELETE #destroy' do
    let(:first_user) { create(:user) }
    let!(:question) { create(:question, user: first_user) }
    it 'Registered user is owner of question' do
      sign_in(first_user)
      expect{ delete :destroy, id: question }.to change(Question, :count).by(-1)
    end
    it 'redirects to index view' do
      sign_in(first_user)
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end
  
end
