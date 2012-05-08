# spec/factories/basic_article_factory.rb

FactoryGirl.define do
  factory :basic_article do
    sequence(:title) { |index| "Basic Article #{index}" }
    format 'plain-text'
  end # factory :basic_article
end # FactoryGirl.define
