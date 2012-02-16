class Article < ActiveRecord::Base
  # id:integer (primary key)
  # created_at:datetime
  # updated_at:datetime
  
  has_one :category_feature,
    :as => :feature,
    :dependent => :destroy
  has_one :category,
    :through => :category_feature
  
  has_many :versions,
    :class_name => "ArticleVersion",
    :dependent => :destroy,
    :order => "created_at" do
      def draft
        where(:published => [false, nil])
      end # method drafts
      
      def published
        where(:published => true)
      end # method published
    end # association :versions
  
  ##################
  # Instance Methods
  
  # Returns the categories containing this article, from largest (top-level) to
  # smallest (the direct parent).
  def categories
    categories = Array.new
    unless self.category.nil?
      categories << self.category
      categories += self.category.ancestors
    end # unless
    categories.reverse
  end # method categories
  
  # Required for polymorphic routing, delegates to published.slug
  def slug
    published.nil? ? nil : published.slug
  end # method slug
  
  ###################
  # Managing Workflow
  
  # Returns the most recent version, regardless of publication status, or nil
  # if there are no versions (this is an error condition!).
  def draft
    self.versions.last
  end # method draft
  
  # Returns true if the most recent version exists and is not published.
  def draft?
    !draft.nil? && !draft.published?
  end # method draft?
  
  # Returns the most recent published version, or nil if there are no published
  # versions.
  def published
    self.versions.published.last
  end # method published
  
  # Returns true if there exists at least one published version.
  def published?
    !self.versions.published.last.nil?
  end # method published?
end # model Article
