source 'http://rubygems.org'

gem 'rails', '3.2.1'

# Use PostgreSQL database
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier',     '>= 1.0.3'
end # group :assets

gem 'haml'
gem 'haml-rails'
gem 'jquery-rails'

gem 'acts_as_sluggable', :git => 'git@github.com:sleepingkingstudios/acts_as_sluggable.git'
gem 'acts_as_tree',      :git => 'git@github.com:sleepingkingstudios/acts_as_tree.git'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

group :test, :development do
  gem "rspec-rails", ">= 2.4"
end # group :test, :development

group :test do
  gem "factory_girl_rails"
end # group :test
