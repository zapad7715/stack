require 'rails_helper'

RSpec.describe Attachment, type: :model do
  
  describe "validations" do
    it { should validate_presence_of :file }
  end
  
  describe 'associations' do
    it{ should belong_to :attachable }    
  end
end
