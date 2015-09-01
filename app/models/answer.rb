class Answer < ActiveRecord::Base
  default_scope { order(best: 'DESC') }
  
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable
  
  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :body, presence: true, length: { minimum: 3, maximum: 10000 }
  
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  
  def best_answer
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
