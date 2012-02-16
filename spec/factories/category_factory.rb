# spec/factories/category_factory.rb

FactoryGirl.define do
  factory :category do
    sequence(:title) { |index| "Category #{index}" }
  end # factory :category
end # FactoryGirl.define
