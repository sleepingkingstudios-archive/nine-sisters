# spec/factories/category_feature_factory.rb

require 'models/generic_feature_helper'

FactoryGirl.define do
  factory :category_feature do
    category
    association :feature, :factory => :generic_feature
  end # factory :category_feature
end # FactoryGirl.define
