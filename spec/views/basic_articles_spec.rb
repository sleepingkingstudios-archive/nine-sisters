require 'spec_helper'

describe "admin/basic_articles" do
  def self.fixtures
    # reset table
    BasicArticle.destroy_all
    
    articles = Array.new
    articles << FactoryGirl.create(:basic_article, :title => "The Sword of Shannara")
    articles << FactoryGirl.create(:basic_article, :title => "The Elfstones of Shannara")
    articles << FactoryGirl.create(:basic_article, :title => "The Wishsong of Shannara")
    
    return articles
  end # class method fixtures
  
  
end # describe admin/basic_articles
