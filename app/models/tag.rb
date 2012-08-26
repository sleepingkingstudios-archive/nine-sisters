class Tag < ActiveRecord::Base
  # id:integer (primary key)
  # title:string
  # slug:string (acts_as_sluggable)
  # slug_lock:boolean (acts_as_sluggable)
  # created_at:datetime
  # updated_at:datetime
  
  acts_as_sluggable :title, :allow_lock => true, :callback_method => :to_slug
  
  #########################################
  # Associations, Validations and Callbacks
  
  has_many :taggings, :dependent => :destroy
  
  validates :title, :presence => true, :uniqueness => true
  
  ##################
  # Instance Methods
  
  def to_slug
    self.title.to_s.underscore.gsub(/['"]/,"").parameterize('-').gsub(/[\s_-]+/, "-")
  end # method to_slug
  private :to_slug
end # model Tag
