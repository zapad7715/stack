class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  
  validates :title, presence: true, length: { minimum: 3, maximum: 250   }
  validates :body, presence: true, length: { minimum: 3, maximum: 10000 }
  validates :user_id, presence: true
  
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
