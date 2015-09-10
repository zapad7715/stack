require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'validations' do
    it { should validate_inclusion_of(:value).in_array([-1, 1]) }
    context 'for answer' do
      let(:answer){ create(:answer) }
      before { create(:vote, votable: answer) }
      it do 
        should validate_uniqueness_of(:votable_type).scoped_to(:votable_id)
      end 
      it do
        should validate_uniqueness_of(:votable_id).scoped_to(:votable_type)
      end 
    end
  end
  
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :votable }    
  end
end
