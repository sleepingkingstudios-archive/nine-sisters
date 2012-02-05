# spec/factories.rb

FactoryGirl.define do
  factory :category do
    sequence(:title) { |index| "Category #{index}" }
  end # factory :category
  
  factory :setting do
    sequence(:key) { |index| "key-#{index}" }
    sequence(:value) { |index| "Value #{index}" }
  end # factory :setting
end # define
