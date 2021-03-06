require 'rails_helper'

RSpec.describe Question, type: :model do
  
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
    it { should validate_length_of(:title).is_at_most(250) }
    it { should validate_length_of(:body ).is_at_most(10_000) }
    it { should validate_length_of(:title).is_at_least(3) }
    it { should validate_length_of(:body ).is_at_least(3) }
  end
  
  describe "assotiations" do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should belong_to(:user) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end
  
  describe 'nested attributes' do
    it { should accept_nested_attributes_for :attachments }
  end
end
