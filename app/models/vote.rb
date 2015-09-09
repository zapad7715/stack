class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user
  validates :value, inclusion: { in: [-1, 1] }
  validates :user, :votable, presence: true
  validates :votable_id, uniqueness: true
  validates :votable_type, uniqueness: true
end
