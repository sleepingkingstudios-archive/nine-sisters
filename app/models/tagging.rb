class Tagging < ActiveRecord::Base
  # id:integer (primary key)
  # tag_id:integer (foreign key)
  # taggable_id:integer (foreign key; polymorphic)
  # taggable_type:string (foreign key; polymorphic)
  # created_at:datetime
  # updated_at:datetime
  
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  
  validates :tag_id, :uniqueness => {
    :message => "has already been assigned",
    :scope => [:taggable_id, :taggable_type]
  } # end validation
end # model Tagging
