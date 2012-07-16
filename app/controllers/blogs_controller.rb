class BlogsController < ApplicationController
  before_filter :find_posts, :only => %w(show)
  before_filter :find_tags,  :only => %w(show)
  
  # GET /blog
  # GET /blogs/:id
  def show; end
  
  def find_blog
    @blog = Blog.find(params[:id])
  end # helper find_blog
  private :find_blog
  
  def find_tag
    @tag = params[:tag].nil? ? nil : Tag.find_by_slug(params[:tag])
  end # helper find_tag
  
  def find_tags
    @tags = Tag.all
  end # helper find_tags
  
  def find_posts
    find_blog
    find_tag
    
    posts = @blog.posts.published
    
    logger.debug("#{self}::find_posts()")
    
    unless @tag.nil?
      posts = posts.joins(:taggings).where("tag_id = ?", @tag.id)
    end # unless
    
    @posts = posts.limit(5).offset(5 * (params[:page_id].to_i || 0))
    @posts_count = @blog.posts.published.count
  end # helper find_posts
  private :find_posts
end # controller BlogsController
