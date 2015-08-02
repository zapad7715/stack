class Answer < ActiveRecord::Base
  default_scope { order(best: 'DESC') }
  
  belongs_to :question
  belongs_to :user
  
  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :body, presence: true, length: { minimum: 3, maximum: 10000 }
  
  def best_answer
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
