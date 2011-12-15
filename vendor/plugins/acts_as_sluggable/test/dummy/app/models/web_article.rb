class WebArticle < ActiveRecord::Base
  acts_as_sluggable :title, :column => :url
end
