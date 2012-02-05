require 'spec_helper'

describe Setting do
  before :each do described_class.class_variable_set :@@settings, nil; end
  
  after :all do described_class.class_variable_set :@@settings, nil; end
  
  describe "validation" do
    describe "validates with key and value" do
      before :each do
        @setting = FactoryGirl.build :setting
        @setting.valid?
      end # before :each
      subject { @setting }
      
      it { subject.should be_valid }
    end # describe validates with key and value
    
    describe "setting must have a key" do
      before :each do
        @setting = FactoryGirl.build :setting, :key => nil
        @setting.valid? # force validation
      end # before :each
      subject { @setting }
      
      it { subject.should_not be_valid }
      it { subject.errors.messages[:key].should include "can't be blank" }
    end # describe setting must have a key
    
    describe "key must be unique" do
      before :each do
        @valid = FactoryGirl.create :setting
        @setting = FactoryGirl.build :setting, :key => @valid.key
        @setting.valid?
      end # before :each
      subject { @setting }
      
      it { subject.should_not be_valid }
      it { subject.errors.messages[:key].should include "has already been taken" }
    end # describe key must be unique
    
    describe "navigation items" do
      describe "validates with comma-separated array of labels and paths" do
        before :each do
          @setting = FactoryGirl.build :setting, :key => :navigation, :value => "foo=/bar,baz=/wibble/wobble"
          @setting.valid?
        end # before :each
        subject { @setting }
        
        it { subject.should be_valid }
      end # describe validates ...
      
      describe "must be comma-separated array of labels and paths" do
        before :each do
          @setting = FactoryGirl.build :setting, :key => :navigation
          @setting.valid?
        end # before :each
        subject { @setting }
        
        it { subject.should_not be_valid }
        it { subject.errors.messages[:value].should include "must be a label and a path, separated by an equals sign" }
      end # describe must be comma-separated array ...
    end # describe "navigation items"
  end # describe validation
end # describe Setting
