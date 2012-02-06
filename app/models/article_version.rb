class ArticleVersion < ActiveRecord::Base
  # id:integer (primary key)
  # article_id:integer (belongs_to :article)
  # user_id:integer (belongs_to :user)
  # title:string
  # slug:string
  # format:string
  # contents:text
  # published:boolean
  # created_at:datetime
  # updated_at:datetime
  
  attr_accessible :title, :slug, :format, :contents
  
  belongs_to :article
  belongs_to :user
  
  validates :article_id, :presence => true
  
  def slug
    (str = super.to_s).empty? ? self.title.underscore.tr(' ', '_') : str
  end # method slug
end # model ArticleVersion
