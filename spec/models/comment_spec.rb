require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { should validate_length_of(:comment_body).is_at_least(3).is_at_most(1000) }
    it { should validate_presence_of :user }
  end
  
  describe 'associations' do
    it { should belong_to :commentable }
    it { should belong_to :user}
  end
end
