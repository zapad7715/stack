require 'rails_helper'

RSpec.describe Authorization, type: :model do
  describe 'validations' do
    it { should belong_to(:user) }
  end
  describe 'associations' do
    it { should validate_presence_of :uid}
    it { should validate_presence_of :provider }
  end
end
