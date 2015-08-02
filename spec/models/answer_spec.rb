require 'rails_helper'

RSpec.describe Answer, type: :model do
  
  describe 'validations' do
    it { should validate_presence_of :question_id }
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
    it { should validate_length_of(:body ).is_at_most(10_000) }
    it { should validate_length_of(:body ).is_at_least(3) }
  end
  
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to :user }
  end
  
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:another_answer) { create(:answer, question: question) }

  describe 'method best_answer' do
   it 'marks answer as best' do
     answer.best_answer

     expect(answer.best).to be true
    end
    it 'marks another answer as best if best answer already exists' do
      answer.update!(best: true)

      another_answer.best_answer
      answer.reload

      expect(another_answer.best).to be true
      expect(answer.best).to be false

    end
  end
end
