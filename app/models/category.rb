class Category < ActiveRecord::Base
  # id:integer (primary key)
  # title:string
  # slug:string (acts_as_sluggable)
  # slug_lock:boolean (acts_as_sluggable)
  # parent_id:integer (acts_as_tree)
  # created_at:datetime
  # updated_at:datetime
  
  acts_as_sluggable :title, :allow_lock => true
  acts_as_tree
  
  has_many :category_features,
    :class_name => "CategoryFeature",
    :dependent => :destroy
  
  validates :title, :presence => true
  validates :slug,
    :presence => true,
    :uniqueness => { :scope => :parent_id },
    :does_not_match_feature => true
  
  scope :top_level, where(:parent_id => nil)
  
  class << self
    def find_by_path(path)
      categories = Array.new
      path.split("/").each do |slug|
        category = (category.children || Category).find_by_slug(slug)
        categories << category
      end # each
    end # class method find_by_path
  end # class << self
  
  def features
    self.category_features.includes(:feature).map(&:feature)
  end # method features
  
  def path
    (self.parent.nil? ? "/" : "#{self.parent.path}/") + self.slug
  end # method path
end # model Category
