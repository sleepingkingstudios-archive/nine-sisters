require 'spec_helper'

describe CategoryFeature do
  let(:categories) {
    (0..1).map { |index| FactoryGirl.create(:category) }
  } # end let :categories
  
  let(:features) {
    (0..2).map { |index| FactoryGirl.create(:generic_feature) }
  } # end let :features
  
  describe "initialization" do
    let(:params) {
      { category_id: categories.first.id,
        feature_id: features.first.id,
        feature_type: "generic_feature"
      } # end anonymous Hash
    } # end let :params
    
    describe "requires a feature" do
      subject { described_class.new(params.update( :feature_id => nil )) }
      before :each do subject.valid? end # force validation
      
      it { subject.should_not be_valid }
      it { subject.errors.messages[:feature_id].join.should =~ /can't be blank/i }
    end # describe requires a feature
    
    describe "requires a feature type" do
      subject { described_class.new(params.update( :feature_id => nil )) }
      before :each do subject.valid? end # force validation
      
      it { subject.should_not be_valid }
      it { subject.errors.messages[:feature_id].join.should =~ /can't be blank/i }
    end # describe requires a feature type
    
    it { described_class.new(params).should be_valid }
    it { expect { described_class.create!(params) }.not_to raise_error }
  end # describe initialization
  
  context "(initialized)" do
    describe "validates uniqueness of feature" do
      let(:params) {
        { category_id: categories.first.id,
          feature_id: features.first.id,
          feature_type: "generic_feature"
        } # end anonymous Hash
      } # end let :params
      
      before :each do
        FactoryGirl.create(:category_feature, params)
      end # each
      
      it { FactoryGirl.build(:category_feature, params).should_not be_valid }
      it { FactoryGirl.build(:category_feature, params.update( :feature_type => "other_feature")).should be_valid }
      it { FactoryGirl.build(:category_feature, params.update( :feature_id => features.last.id )).should be_valid }
      
      describe "error message" do
        subject { FactoryGirl.build(:category_feature, params) }
        before :each do subject.valid? end # force validation end
        
        it { subject.errors.messages[:feature_id].join.should =~ /must refer to a unique feature/i }
      end # describe error message
    end # describe validates uniqueness of feature
    
    describe "associations" do
      def self.fixture_data
        [ { category: 0, feature: 0 },
          { category: 1, feature: 1 },
          { category: 1, feature: 2 }
        ] # end anonymous Array
      end # class method fixture_data
      let(:fixture_data) { self.class.fixture_data }
      
      let(:fixtures) {
        fixture_data.map do |data|
          FactoryGirl.create(:category_feature,
            :category => categories[data[:category]],
            :feature  => features[data[:feature]])
        end # map
      } # end let :fixtures
      
      fixture_data.count.times do |index|
        context do
          subject { fixtures[index] }
          
          describe "belongs_to :category" do
            it { subject.category.should == categories[fixture_data[index][:category]] }
            it { subject.category_id.should be categories[fixture_data[index][:category]].id }
          end # describe belongs_to :category
          
          describe "belongs_to :feature" do
            it { subject.feature.should == features[fixture_data[index][:feature]] }
            it { subject.feature_id.should be features[fixture_data[index][:feature]].id }
          end # describe belongs_to :feature
        end # anonymous context
      end # times
    end # describe associations
    
    describe "top level scope" do
      def self.fixture_data
        [ { category: nil, feature: 0 },
          { category: nil, feature: 1 },
          { category: 0,   feature: 2 }
        ] # end anonymous Array
      end # class method fixture_data
      let(:fixture_data) { self.class.fixture_data }
      
      let!(:fixtures) {
        fixture_data.map do |data|
          FactoryGirl.create(:category_feature,
            :category => (categories[data[:category]] unless data[:category].nil?),
            :feature => features[data[:feature]])
        end # map
      } # end let :fixtures
      
      fixture_data.each_with_index do |data, index|
        context do
          subject { fixtures[index] }
          
          if data[:category].nil?
            it { described_class.top_level.should include subject }
          else
            it { described_class.top_level.should_not include subject }
          end # unless-else
        end # anonymous context
      end # times
    end # describe top level scope
  end # context (initialized)
end # describe CategoryFeature
