require 'spec_helper'

describe Admin::BasicArticlesController do
  def self.fixtures
    # reset table
    BasicArticle.destroy_all
    
    articles = Array.new
    articles << FactoryGirl.create(:basic_article, :title => "The Sword of Shannara")
    articles << FactoryGirl.create(:basic_article, :title => "The Elfstones of Shannara")
    articles << FactoryGirl.create(:basic_article, :title => "The Wishsong of Shannara")
    
    return articles
  end # class method fixtures
=begin
  describe "show action" do
    let!(:fixtures) { self.class.fixtures }
    
    before :each do get :show, :id => fixtures.first.id; end
    
    it "assigns article to @articles" do
      assigns(:article).should == fixtures.first
    end # it assigns article ...
    
    it "renders /admin/basic_articles/show" do
      response.should render_template "admin/basic_articles/show"
    end # it renders ...
  end # describe show action
=end
end # describe Admin::BasicArticlesController
