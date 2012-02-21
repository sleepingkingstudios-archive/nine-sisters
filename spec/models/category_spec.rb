require 'spec_helper'

describe Category do
  describe "validation" do
    before :each do
      @category = FactoryGirl.build(:category, :title => nil)
      @category.valid? # force validation
    end # before :each
    
    subject { @category }
    
    it { subject.should_not be_valid }
    it { subject.errors.messages[:title].should include "can't be blank" }
  end # describe validation
  
  describe "acts_as_sluggable" do
    before :each do
      @category = FactoryGirl.create(:category)
    end # before :each
    
    subject { @category }
    
    it { subject.slug.should == subject.title.downcase.tr(" ", "-") }
    it { subject.path.should == "/#{subject.title.downcase.tr(" ", "-")}" }
    
    describe "validation" do
      before :each do
        FactoryGirl.create(:category, :title => "The Name of the Rose")
        @category = FactoryGirl.build(:category, :title => "Il Nome della Rosa")
      end # before :each
      subject { @category }
      
      it { subject.should be_valid }
      
      describe "slug cannot be blank" do
        before :each do subject.slug = nil end
        
        it { subject.should_not be_valid }
        
        context do
          before :each do subject.valid? end
          
          it { subject.errors.messages[:slug].join.should =~ /can't be blank/i }
        end # anonymous context
      end # describe slug cannot be blank
      
      describe "slug must be unique within scope" do
        before :each do subject.slug = "the-name-of-the-rose" end
          
        it { subject.should_not be_valid }
        
        context do
          before :each do subject.valid? end
          
          it { subject.errors.messages[:slug].join.should =~ /has already been taken/i }
        end # anonymous context
      end # describe slug must be unique within scope
      
      describe "slug can be shared across scopes" do
        before :each do
          subject.parent = FactoryGirl.create :category, :title => :literature
          subject.slug = "the-name-of-the-rose"
        end # before :each
        
        it { subject.should be_valid }
      end # describe slug can be shared across scopes
    end # describe validation
  end # describe acts_as_sluggable
  
  describe "acts_as_tree" do
    before :each do
      @weapons = FactoryGirl.create(:category, :title => "Weapons")
    end # before :each
    
    subject { @weapons }
    
    it { expect { subject.children }.not_to raise_error }
    it { subject.children.should be_a Array }
    
    describe "creating associations" do
      it { subject.children.build(:title => "Bows").save.should be true }
      it { subject.children.create(:title => "Polearms").should be_a Category }
    end # describe creating associations
    
    describe "(initialized)" do
      before :each do
        @swords = FactoryGirl.create(:category, :title => "Swords")
        @weapons.children << @swords
      end # before :each
      
      it { subject.children.should include @swords }
      it { @swords.parent.should == subject }
      it { @swords.path.should == "/weapons/swords" }
      
      describe "top_level scope" do
        it { described_class.top_level.should include @weapons }
        it { described_class.top_level.should_not include @swords }
      end # describe top_level scope
      
      describe "scoped uniqueness of slugs" do
        it "validates slug uniqueness for top-level categories" do
          category = FactoryGirl.build :category, :title => "Weapons"
          category.should_not be_valid
          category.errors.messages[:slug].should include "has already been taken"
        end # it validates slug uniqueness ...
        
        it "validates slug uniqueness for child categories" do
          category = @weapons.children.build :title => "Swords"
          category.should_not be_valid
          category.errors.messages[:slug].should include "has already been taken"
        end # it validates slug uniqueness ...
        
        it "allows non-unique slugs in different scopes" do
          category = FactoryGirl.build :category, :title => "Swords"
          category.should be_valid
        end # it validates slug uniqueness ...
      end # describe ... uniqueness of slugs
      
      describe "validator prevents cycle of ancestors" do
        before :each do
          @famous_swords = FactoryGirl.create(:category, :title => "Famous Swords")
          @swords.children << @famous_swords
          @weapons.parent = @famous_swords
          @weapons.valid? # force validation
        end # before :each
        
        it { @weapons.should_not be_valid }
        it { @weapons.errors.messages[:parent_id].join().should =~ /cannot be its own descendant/i }
      end # describe validator prevents cycle of ancestors
    end # describe (initialized)
  end # describe acts_as_tree
  
  describe "features" do
    def self.feature_data
      [ {}, {}, {} ]
    end # self.feature_data
    let(:feature_data) { self.class.feature_data }
    
    let(:generic_features) {
      feature_data.map { |data| FactoryGirl.create(:generic_feature, data) }
    } # end let :generic_features
    
    let!(:category_features) {
      generic_features.map { |feature| FactoryGirl.create(:category_feature,
        :category => subject,
        :feature => feature)
      } # end map
    } # end let :category_features
    
    subject { FactoryGirl.create(:category) }
    
    describe "features method" do
      feature_data.each_with_index do |data, index|
        it { subject.features.should include generic_features[index] }
      end # each_with_index
    end # describe features
    
    describe "has_many :category_features" do
      feature_data.count.times do |index|
        context do
          let(:category_feature) { category_features[index] }
          let(:force_reload) { true } # this is required for some reason
          
          it { category_feature.category_id.should be subject.id }
          it { category_feature.category should == subject }
          it { subject.category_features(force_reload).should include category_feature }
        end # anonymous context
      end # times
    end # describe has_many :category_features
    
    describe "cannot set child category's slug to feature's slug" do
      let(:child_category) {
        FactoryGirl.build(:category,
          :parent => subject).tap { |o| o.valid? }
      } # let :child_category
      
      let!(:category_feature) {
        FactoryGirl.create(:category_feature,
          :category => subject,
          :feature => FactoryGirl.create(:generic_feature, :slug => child_category.slug))
      } # end let :feature
      
      before :each do child_category.valid?; end
      
      it { child_category.should_not be_valid }
      it { child_category.errors.messages[:slug].join.should =~ /is already taken/i }
    end # describe cannot set child category's slug to feature's slug
    
    describe "cannot have top level category with top level feature's slug" do
      subject { FactoryGirl.create(:category) }
      
      let!(:category_feature) {
        FactoryGirl.create(:category_feature,
          :category => nil,
          :feature => FactoryGirl.create(:generic_feature, :slug => subject.slug))
      } # end let :category_feature
      
      before :each do subject.valid? end
      
      it { subject.should_not be_valid }
      it { subject.errors.messages[:slug].join.should =~ /is already taken/i}
    end # describe
  end # describe features
end # describe Category
