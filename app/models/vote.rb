class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user
  validates :value, inclusion: { in: [-1, 1] }
  validates :user, :votable, presence: true
  validates :votable_id, presence: true, uniqueness: { scope: :votable_type }
  validates :votable_type, presence: true, uniqueness: { scope: :votable_id }
end
