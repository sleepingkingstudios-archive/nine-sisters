# encoding: utf-8
# acts_as_sluggable/test/acts_as_sluggable_test.rb

require 'test_helper'

class ActsAsSluggableTest < ActiveSupport::TestCase
  test "populates_slug_with_default_options" do
    article = BasicArticle.create :title => "On The Origin of Species"

    assert_equal "On The Origin of Species", article.title
    assert_equal "on-the-origin-of-species", article.slug
  end # test populates_slug_with_default_options
  
  test "populates_slug_with_alternate_source" do
    author = ArticleAuthor.create :name => "Sun Tzu", :slug => "sima-yi"
    
    assert_equal "Sun Tzu", author.name
    assert_equal "sun-tzu", author.slug
  end # test populates_slug_with_alternate_source
  
  test "bulk_assignment_of_slug_fails" do
    article = BasicArticle.create :title => "A Brief History of Time", :slug => "atlas-shrugged"
    
    assert_equal "A Brief History of Time", article.title
    assert_equal "a-brief-history-of-time", article.slug
  end # test bulk_assignment_of_slug_fails
  
  test "removes_accented_characters" do
    article = BasicArticle.create :title => "In Search of Schrödinger's Cat"
    
    assert_equal "In Search of Schrödinger's Cat", article.title
    assert_equal "in-search-of-schrodinger's-cat", article.slug
  end # test removes_accented_characters
  
  test "populates_alternate_attribute_and_column" do
    article = WebArticle.create :title => "Outliers: The Story of Success"
    
    assert_equal "Outliers: The Story of Success", article.title
    assert_equal "outliers:-the-story-of-success", article.url
  end # test populates_alternate_attribute_and_column
  
  test "validates_presence_of_slugs" do
    article = BasicArticle.create
    
    assert article.invalid? && !article.errors.messages[:slug].nil?, "Should not validate with empty slug."
    assert article.errors.messages[:slug].include?("can't be blank"), "Errors should include \"can't be blank\""
  end # test validates_presence_of_slugs
  
  test "validates_uniqueness_of_slugs" do
    first_article  = BasicArticle.create :title => "FROM THE EARTH TO THE MOON"
    second_article = BasicArticle.new    :title => "from the earth to the moon"
    
    assert second_article.invalid? && !second_article.errors.messages[:slug].nil?, "Should not validate with duplicate slug."
    assert second_article.errors.messages[:slug].include?("has already been taken"), "Errors should include \"has already been taken\""
  end # test validates_uniqueness_of_slugs
end # test_case ActsAsSluggableTest
