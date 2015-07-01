class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  
  validates :title, presence: true, length: { minimum: 3, maximum: 250   }
  validates :body, presence: true, length: { minimum: 3, maximum: 10000 }
  validates :user_id, presence: true
end
