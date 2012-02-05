class Article < ActiveRecord::Base
  # id:integer (primary key)
  # category_id:integer (belongs_to :category)
  # created_at:datetime
  # updated_at:datetime
  
  belongs_to :category
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
  
  def has_draft?
    return false if (draft = versions.draft.last).nil?
    return true if (published = versions.published.last).nil?
    
    draft.created_at > published.created_at
  end # method has_draft?
  
  def published?
    !(versions.published.last.nil?)
  end # method is_published?
  
  def published_at
    (version = versions.published.last) ? version.created_at : ""
  end # method published_at
  
  def status
    if self.published? and self.has_draft?
      return "Published, with Draft"
    elsif self.published?
      return "Published"
    else
      return "Draft"
    end # if-else
  end # method status
  
  ##################
  # Draft Properties
  
  def draft_title
    versions.last.title || ""
  end # method draft_title
  
  def draft_slug
    versions.last.slug || ""
  end # method draft_slug
  
  def draft_format
    versions.last.format || ""
  end # method draft_format
  
  def draft_contents
    versions.last.contents || ""
  end # method draft_contents
  
  ######################
  # Published Properties
  
  def title
    (version = versions.published.last) ? version.title : ""
  end # method title
  
  def slug
    (version = versions.published.last) ? version.slug : ""
  end # method slug
  
  def format
    (version = versions.published.last) ? version.format : "text"
  end # method format
  
  def contents
    (version = versions.published.last) ? version.contents : ""
  end # method contents
end # model Article
