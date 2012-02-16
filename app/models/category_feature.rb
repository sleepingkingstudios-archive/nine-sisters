class CategoryFeature < ActiveRecord::Base
  # id:integer # primary key
  # category_id:integer
  # feature_id:integer
  # feature_type:string
  
  # Note: each feature instance is responsible for maintaining its own
  # CategoryFeature join, even if it is at the top level (no category).
  # Otherwise, top level features will not be accessible or visible.
  
  scope :top_level, where(:category_id => nil)
  
  belongs_to :category
  belongs_to :feature, :polymorphic => true
  
  validates :feature_id, :feature_type, :presence => true
  validates :feature_id, :uniqueness => {
    :scope => :feature_type,
    :message => "must refer to a unique feature" }
  
  def slug
    feature.slug
  end # method slug
end # model CategoryFeature
