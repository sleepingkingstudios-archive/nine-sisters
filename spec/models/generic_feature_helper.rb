# spec/models/generic_feature_helper.rb

class GenericFeature < ActiveRecord::Base
  # slug:string
end # model GenericFeature

standard_out, $stdout = $stdout, StringIO.new
%w(generic_features)
if ActiveRecord::Base.connection.tables.include? "generic_features"
  ActiveRecord::Base.connection.drop_table("generic_features")
end # if

ActiveRecord::Schema.define(:version => 1) do
  create_table :generic_features do |t|
    t.column :slug, :string
    
    t.timestamps
  end # create_table
end # ActiveRecord::Schema.define

$stdout = standard_out

FactoryGirl.define do
  factory :generic_feature do
    sequence(:slug) { |index| "feature-#{index}" }
  end # factory :generic_feature
end # FactoryGirl.define
