FactoryGirl.define do
  sequence :title do |n|
    "My string#{n}"
  end
  sequence :body do |n|
    "My body#{n}"
  end
  factory :question do
    user
    title 
    body
  end
  
  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
  
end
