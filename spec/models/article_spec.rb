require 'spec_helper'

describe Article do
  describe "initialization" do
    before :each do
      @article = Factory.build :article
    end # before :each
    subject { @article }
    
    it { expect { @article.save }.not_to raise_error }
  end # describe initialization
  
  context "(initialized)" do
    before :each do
      @article = Factory(:article)
    end # before :each
    subject { @article }
    
    describe "categories" do
      before :each do
        category = nil
        @categories = ["Weapons", "Swords", "Japanese Swords"].map do |title|
          category = Factory.create :category,
            :parent_id => (category ? category.id : nil),
            :title     => title
        end # map
        @article.category = @categories.last
        @article.save
      end # before :each
      
      it { subject.category.should be @categories.last }
      it { subject.categories.should == @categories }
    end # describe categories
    
    describe "categories (top-level)" do
      it { subject.category.should be nil }
      it { subject.categories.should == Array.new }
    end # categories
    
    describe "versions" do
      shared_examples "an object with draft and published versions" do
        let(:draft_versions) { versions.delete_if(&:published) }
        let(:published_versions) { versions.keep_if(&:published) }
        
        it { subject.versions.should == versions }
        it { subject.versions.draft.should == draft_versions }
        it { subject.versions.published.should == published_versions }
        
        it { subject.draft.should == versions.last }
        it { subject.published.should == published_versions.last }
        
        it { subject.draft?.should == (!versions.last.nil? && !versions.last.published) }
        it { subject.published?.should == !published_versions.empty? }
      end # shared_examples
      
      context "(no versions)" do
        before :each do
          @versions = Array.new
        end # before :each
        let(:versions) { @versions }
        
        it_should_behave_like "an object with draft and published versions"
      end # context (no versions)
      
      context "(one draft)" do
        before :each do
          @versions = Array.new
          
          @versions << Factory(:article_version, :article => @article)
        end # before :each
        let(:versions) { @versions }
        
        it_should_behave_like "an object with draft and published versions"
      end # context (one draft)
      
      context "(one published)" do
        before :each do
          @versions = Array.new
          
          @versions << Factory(:article_version, :article => @article, :published => true)
        end # before :each
        let(:versions) { @versions }
        
        it_should_behave_like "an object with draft and published versions"
      end # context (one draft)
      
      context "(one draft, one published)" do
        before :each do
          @versions = Array.new
          
          @versions << Factory(:article_version, :article => @article)
          @versions << Factory(:article_version, :article => @article, :published => true)
        end # before :each
        let(:versions) { @versions }
        
        it_should_behave_like "an object with draft and published versions"
      end # context (one draft, one published)
      
      context "(one published, one draft)" do
        before :each do
          @versions = Array.new
          
          @versions << Factory(:article_version, :article => @article, :published => true)
          @versions << Factory(:article_version, :article => @article)
        end # before :each
        let(:versions) { @versions }
        
        it_should_behave_like "an object with draft and published versions"
      end # context (one draft, one published)
    end # describe versions
  end # context (initialized)
end # describe Article
