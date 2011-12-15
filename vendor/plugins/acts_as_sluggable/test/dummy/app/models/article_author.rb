class ArticleAuthor < ActiveRecord::Base
  acts_as_sluggable :name
end
