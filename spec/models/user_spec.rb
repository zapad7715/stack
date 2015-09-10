require "rails_helper"

RSpec.describe User, type: :model do
  
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end
  
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
  end
end