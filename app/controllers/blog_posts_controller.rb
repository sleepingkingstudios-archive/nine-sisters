class BlogPostsController < ApplicationController
  before_filter :find_post,  :only => %w(show)
  
  def show; end
  
  def find_blog
    @blog = Blog.find(params[:blog_id])
  end # helper find_blog
  private :find_blog
  
  def find_post
    posts = (@blog || find_blog).posts
    
    return if !(@post = find_post_by_field posts, :slug, params[:post_id]).nil?
    return if !(@post = find_post_by_field posts, :id,   params[:post_id]).nil?
  end # helper find_post
  private :find_post
  
  def find_post_by_field(collection, field, value)
    begin
      return collection.send :"find_by_#{field}", value
    rescue NoMethodError, ActiveRecord::RecordNotFound
      return nil
    end # begin-rescue-end
  end # helper find_post_by_field
  private :find_post_by_field
  
  def close_tags(html_string)
    
  end # method close_tags
end # controller BlogPostsController
