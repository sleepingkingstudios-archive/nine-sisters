class TagsController < ApplicationController
  before_filter :find_posts, :only => %w(index)
  before_filter :find_tags, :only => %w(index)
  
  def index; end
  
  def find_blog
    @blog = Blog.find(params[:blog_id])
  end # helper find_blog
  private :find_blog
  
  def find_posts
    @posts = find_blog.posts
  end # helper find_posts
  private :find_posts
  
  def find_tags
    @tags = Tag.all
  end # helper find_tags
end # controller TagsController
