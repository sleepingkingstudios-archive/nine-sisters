# acts_as_sluggable/test/dummy/app/models/basic_article.rb

class BasicArticle < ActiveRecord::Base
  acts_as_sluggable :title
end # model Basic Article
