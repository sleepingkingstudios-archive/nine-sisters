class Blog < ActiveRecord::Base
  # The Blog model represents a sequence of content entries.
  #
  # @fields:
  # - id:integer (primary key)
  # - title:string
  # - slug:string (acts_as_sluggable)
  # - slug_lock:boolean (acts_as_sluggable)
  # - created_at:datetime
  # - updated_at:datetime
  
  acts_as_sluggable :title, :allow_lock => true
  
  #########################################
  # Associations, Validations and Callbacks
  
  has_many :posts, :class_name => "BlogPost", :dependent => :destroy
  
  validates :title, :presence => true
  
  # Association Scopes
  
  def recent_posts(limit = 5)
    self.posts.published.limit(limit).order('published_at')
  end # method recent_posts
  
  ##################
  # Instance Methods
  
  def count
    BlogPost.count
  end # method count
end # model Blog
