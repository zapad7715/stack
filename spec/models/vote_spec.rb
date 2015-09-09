require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'validations' do
    it { should validate_inclusion_of(:value).in_array([-1, 1]) }
    it { should validate_uniqueness_of :votable_id }
    it { should validate_uniqueness_of :votable_type }
  end
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :votable }    
  end
end
