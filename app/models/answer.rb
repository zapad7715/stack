class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  
  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :body, presence: true, length: { minimum: 3, maximum: 10000 }
end
