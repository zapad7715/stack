class Question < ActiveRecord::Base
  include Attachable
  include Votable
  
  belongs_to :user
  has_many :answers, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 3, maximum: 250   }
  validates :body, presence: true, length: { minimum: 3, maximum: 10000 }
  validates :user_id, presence: true
  
end
