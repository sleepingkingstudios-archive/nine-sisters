class Category < ActiveRecord::Base
  # id:integer (primary key)
  # title:string
  # slug:string (acts_as_sluggable)
  # parent_id:integer (acts_as_tree)
  # created_at:datetime
  # updated_at:datetime
  
  acts_as_sluggable :title, :uniqueness => false
  acts_as_tree
  
  has_many :articles
  
  validates :title, :presence => :true
  validates_uniqueness_of :slug, :scope => :parent_id
  
  scope :top_level, where(:parent_id => nil)
  
  class << self
    def find_by_path(path)
      categories = Array.new
      path.split("/").each do |slug|
        category = (category.children || Category).find_by_slug(slug)
        categories << category
      end # each
    end # class method find_by_path
    
    def features
      @@features ||= [:articles]
    end # class method features
  end # class << self
  
  def features
    features = Array.new
    Category.features.each do |key|
      Kernel.puts key.inspect
      features += self.send key if self.class.reflections.has_key? key
    end # method features
    features
  end # method features
  
  def path
    (self.parent.nil? ? "/" : "#{self.parent.path}/") + self.slug
  end # method path
  
  def to_param
    self.slug
  end # method to_param
end # class Category
