class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 3, maximum: 250   }
  validates :body , presence: true, length: { minimum: 3, maximum: 10000 }
end
