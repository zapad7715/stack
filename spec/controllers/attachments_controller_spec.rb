require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe "DELETE #destroy" do 
    
    let(:user) {create(:user)}
    let(:question_author) {create(:user)}
    let!(:question) {create(:question, user: question_author)}
    let!(:question_attach) {create(:attachment, attachable: question)}
    
    let(:answer_author) {create(:user)}
    let(:answer) {create(:answer, question: question, user: answer_author)}
    let!(:answer_attach) {create(:attachment, attachable: answer)}
    
    context "Author of question can" do 
      before { sign_in question_author }
      it "delete their attachment" do
        expect {delete :destroy, id: question_attach, format: :js}.to change(Attachment, :count).by(-1)
      end
      it 'renders destroy template' do
        delete :destroy, id: question_attach, format: :js
        expect(response).to render_template :destroy
      end
    end
    
    context 'Author of answer' do
      before { sign_in answer_author }
      it "delete their attachment" do
        expect {delete :destroy, id: answer_attach, format: :js}.to change(Attachment, :count).by(-1)
      end
      it 'renders destroy template' do
        delete :destroy, id: answer_attach, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "Non author" do
      before do
      sign_in(user)        
      end
      it "try delete other attach for question" do
        expect {delete :destroy, id: question_attach, format: :js}.to_not change(Attachment, :count)
      end
      it "try delete other attach for answer" do
        expect {delete :destroy, id: answer_attach, format: :js}.to_not change(Attachment, :count)
      end
      it 'of question, render status 403' do
        delete :destroy, id: question_attach, format: :js
        expect(response.status).to eq(403)
      end
      it 'of answer, render status 403' do
        delete :destroy, id: answer_attach, format: :js
        expect(response.status).to eq(403)
      end
    end
  end
end
