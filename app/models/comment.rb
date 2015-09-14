class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :comment_body, length: { in: 3..1000 }
  validates :user, presence: true
end
