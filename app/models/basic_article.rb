# The BasicArticle model is the minimal implementation of an article model,
# with a title, cached slug value, and formatted contents.
# 
# @fields:
# - id:integer (primary key)
# - title:string
# - slug:string (acts_as_sluggable)
# - slug_lock:boolean (acts_as_sluggable)
# - contents:text
# - format:string
# - created_at:datetime
# - updated_at:datetime
class BasicArticle < ActiveRecord::Base
  acts_as_sluggable :title,
    :allow_lock => true
  
  #########################################
  # Associations, Validations and Callbacks
  
  has_one :category_feature, :as => :feature,
    :dependent => :destroy
  has_one :category, :through => :category_feature
  
  validates :title, :presence => true
  validates :format,
    :inclusion => {
      :in => Proc.new do BasicArticle.formats; end,
      :message => Proc.new do "must be one of the following: #{BasicArticle.formats.map{|str| "\"#{str}\""}.join(" ")}."; end },
    :presence => true
  
  def ensure_has_category_feature
    self.create_category_feature if self.category_feature.nil?
  end # method ensure_has_category_feature
  protected :ensure_has_category_feature
  after_save :ensure_has_category_feature
  
  ###############
  # Class Methods
  
  BUILTIN_FORMATS = ["plain-text"]
  
  class << self
    def formats
      @@formats ||= BasicArticle::BUILTIN_FORMATS
    end # method formats
  end # class << self
  
  ##################
  # Instance Methods
  
  def format=(value)
    super(value.to_s.underscore.gsub(/[\s_]+/,'-'))
  end # mutator format=
end # model BasicArticle
