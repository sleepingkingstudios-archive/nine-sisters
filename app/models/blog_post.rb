class BlogPost < ActiveRecord::Base
  # The BlogPost model represents an entry in a Blog.
  #
  # @fields
  # - id:integer (primary key)
  # - author_id:integer (foreign key)
  # - blog_id:integer (foreign key)
  # - title:string
  # - slug:string (acts_as_sluggable)
  # - slug_lock:boolean (acts_as_sluggable)
  # - contents:text
  # - format:string
  # - created_at:datetime
  # - updated_at:datetime
  
  acts_as_sluggable :title, :allow_lock => true, :callback_method => :to_slug
  
  #########################################
  # Associations, Validations and Callbacks
  
  belongs_to :author, :class_name => User
  belongs_to :blog
  
  validates :title, :presence => true
  validates :slug, :uniqueness => { :scope => :blog_id }
  validates :format,
    :inclusion => {
      :in => Proc.new do BlogPost.formats; end,
      :message => Proc.new do "must be one of the following: #{BlogPost.format_names.map{|str| "\"#{str}\""}.join(" ")}."; end },
    :presence => true
  
  ###############
  # Class Methods
  
  BUILTIN_FORMATS = ["plain-text", "redcarpet"]
  
  class << self
    def formats
      @@formats ||= BlogPost::BUILTIN_FORMATS
    end # method formats
    
    def format_names
      @@formats.map { |format|
        format.split('-').map { |str| 
          str.capitalize
        }.join(" ") # end map
      } # end map
    end # method format_names
  end # class << self
  
  ##################
  # Instance Methods
  
  def format=(value)
    super(value.to_s.underscore.gsub(/[\s_]+/,'-'))
  end # mutator format=
  
  def to_slug
    source = self.title
    source += "-#{self.subtitle}" unless self.subtitle.nil? || self.subtitle.empty?
    source.to_s.underscore.gsub(/['"]/,"").parameterize('-').gsub(/[\s_-]+/, "-")
  end # method to_slug
  private :to_slug
end # model BlogPost
