require 'spec_helper'

describe BasicArticle do
  let(:article_params) {
    { title: "Il Nome della Rosa",
      contents: "The Name of the Rose is the first novel by Italian author Umberto Eco.",
      format: "plain-text"
    } # end anonymous Hash
  } # end let :article_params
  
  describe "initialization" do; end
  
  context "validation" do
    context do
      let(:article) { described_class.new article_params }
      
      it { article.should be_valid }
    end # anonymous context
    
    describe "title must be present" do
      let(:article) { described_class.new article_params.update( :title => nil ) }
      
      it { article.should_not be_valid }
      
      context do
        before :each do article.valid?; end # force validation
        
        it { article.errors.messages[:title].join.should =~ /can't be blank/i }
      end # anonymous context
    end # describe title must be present
    
    describe "format must be present" do
      let(:article) { described_class.new article_params.update( :format => nil ) }
      
      it { article.should_not be_valid }
      
      context do
        before :each do article.valid?; end
        
        it { article.errors.messages[:format].join.should =~ /can't be blank/i }
      end # anonymous context
    end # describe format must be present
    
    describe "format must be defined" do
      BasicArticle::BUILTIN_FORMATS.each do |article_format|
        context do
          let(:article) { described_class.new article_params.update( :format => article_format ) }
          
          it { described_class.formats.should include article_format }
          it { article.should be_valid }
        end # anonymous context
      end # each
      
      context do
        let(:article_format) { "binary" }
        let(:article) { described_class.new article_params.update( :format => article_format ) }
        
        it { described_class.formats.should_not include article_format }
        it { article.should_not be_valid }
        
        context do
          before :each do article.valid?; end
          
          it { article.errors.messages[:format].join.should =~ /must be one of the following/i }
          
          BasicArticle::BUILTIN_FORMATS.each do |article_format|
            it { article.errors.messages[:format].join.should =~ /#{article_format}/i }
          end # each
        end # context do
      end # anonymous context
      
    end # describe format must be defined
  end # context validation
  
  context "initialized" do
    let(:article) { FactoryGirl.build(:basic_article, article_params) }
    
    describe "has_one :category_feature association" do
      it { article.category_feature.should be nil }
      
      context "attempted to save" do
        before :each do
          article.title = nil
          article.save
        end # before :each
        
        it { article.category_feature.should be nil }
      end # context attempted to save
      
      context "saved" do
        before :each do article.save; end
        
        it { article.category_feature.should be_a CategoryFeature }
        it { CategoryFeature.top_level.should include article.category_feature }
        
        context "deleted" do
          before :each do
            @article_id = article.id
            article.destroy
          end # before :each
          
          it { CategoryFeature.exists?( :feature_id => @article_id, :feature_type => BasicArticle ).should be false }
        end # context deleted
      end # context saved
    end # describe has_one :category_feature association
    
    describe "has_one :category association" do
      it { article.category.should be nil }
      
      context "set and saved" do
        let(:category) { FactoryGirl.create(:category, :title => :literature ) }
        
        before :each do
          article.category = category
          article.save
        end # before :each
        
        it { article.category.should == category }
        it { article.category_feature.should be_a CategoryFeature }
        it { article.category_feature.feature.should == article }
        it { article.category_feature.category.should == category }
        
        context "deleted" do
          before :each do article.destroy; end
          
          it { Category.find(category.id).should == category }
        end # context deleted
      end # context created
    end # describe has_one category association
    
    describe "title property" do
      let(:article_title) { "The Name of the Rose" }
      
      it { article.title.should == article_params[:title] }
      it { expect { article.title = article_title }.not_to raise_error }
      
      context do
        before :each do article.title = article_title; end
        
        it { article.title.should == article_title }
      end # anonymous context
    end # describe title property
    
    describe "slug property" do
      let(:article_title) { "The Adventures of William of Baskerville" }
      let(:article_slug) { "the-name-of-the-rose" }
      
      it { article.slug.should be nil }
      
      context "saved" do
        before :each do article.save; end
        
        it { article.slug.should == article_params[:title].underscore.gsub(/[\s_]/,'-') }
        it { expect { article.slug = article_slug }.not_to raise_error }
        
        context "set and saved" do
          before :each do
            article.slug = article_slug
            article.save
          end # before :each
          
          it { article.slug.should == article_slug }
          
          context "updated title and saved" do
            before :each do
              article.title = article_title
              article.save
            end # before :each
            
            it { article.slug.should == article_slug }
          end # context updated title and saved
          
          context "unlocked, updated title and saved" do
            before :each do
              article.slug_lock = false
              article.title = article_title
              article.save
            end # before :each
            
            it { article.slug.should == article_title.underscore.gsub(/[\s_]/,'-') }
          end # context updated title and saved
        end # context updated and saved
      end # context saved
    end # describe slug property
    
    describe "contents property" do
      let(:article_contents) {
        "Eco, being a semiotician, is hailed by semiotics students who like" +
        " to use his novel to explain their discipline."
      } # end let :article_contents
      
      it { article.contents.should == article_params[:contents] }
      it { expect { article.contents = article_contents }.not_to raise_error }
      
      context do
        before :each do article.contents = article_contents; end
        
        it { article.contents.should == article_contents }
      end # anonymous context
    end # describe contents property
    
    describe "format property" do
      let(:article_format) { "Plain Text" }
      
      it { article.format.should == article_params[:format] }
      it { expect { article.format = article_format }.not_to raise_error }
      
      context do
        before :each do article.format = article_format; end
        
        it { article.format.should == article_format.underscore.gsub(/[\s_]+/,'-') }
      end # anonymous context
    end # describe format property
  end # context initialized
end # describe BasicArticle
