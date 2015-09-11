FactoryGirl.define do
  factory :comment do
    comment_body "Comment comment comment"
    association :user
  end

end
