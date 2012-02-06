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
    it { subject.to_param.should == subject.title.downcase.tr(" ", "-") }
    
    describe "validation" do
      before :each do
        @category = FactoryGirl.build(:category, :title => nil)
        @category.valid? # force validation
      end # before :each
      
      subject { @category }
      
      it { subject.should_not be_valid }
      it { subject.errors.messages[:slug].should include "can't be blank" }
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
    end # describe (initialized)
  end # describe acts_as_tree
  
  describe "features" do
    before :each do
      @category = FactoryGirl.build(:category, :title => "Movie Stars")
      @category.articles << FactoryGirl.build(:title => "Bruce Campbell")
    end # before :each
    subject { @category }
    
    it { @category.articles.should include "Bruce Campbell" }
  end # describe features
end # describe Category
