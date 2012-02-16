# spec/factories/setting_factory.rb

FactoryGirl.define do
  factory :setting do
    sequence(:key) { |index| "key-#{index}" }
    sequence(:value) { |index| "Value #{index}" }
  end # factory :setting
end # define
