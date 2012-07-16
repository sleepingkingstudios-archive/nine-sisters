class Admin::BlogPostsController < ApplicationController
  before_filter :build_post, :only => %w(create new)
  before_filter :find_post,  :only => %w(destroy edit publish show update)
  before_filter :find_post_collection, :only => %w(index)
  
  # POST /admin/blogs/:blog_id/posts
  def create
    preprocess_tags
    
    if @post.save
      append_flash :notice, "Post was successfully created", true
      redirect_to admin_blog_post_path(@blog, @post)
    else
      render :new
    end # if-else
  end # action create
  
  # DELETE /admin/blogs/:blog_id/posts/:id
  def destroy
    logger.debug @post.inspect
    @blog.posts.destroy(@post)
    
    append_flash :warning, "Post was successfully deleted", true
    redirect_to admin_blog_posts_path(@blog)
  end # action destroy
  
  # GET /admin/blogs/:blog_id/posts/:id/edit
  def edit; end
  
  # GET /admin/blogs/:blog_id/posts
  def index; end
  
  # GET /admin/blogs/:blog_id/posts/new
  def new; end
  
  # PUT /admin/blogs/:blog_id/posts/:id/publish
  def publish
    if @post.publish!
      append_flash :notice, "Post was successfully published", true
      redirect_to admin_blog_post_path(@blog, @post) and return
    else
      append_flash :error, "Unable to publish post", true
      redirect_to edit_admin_blog_post_path(@blog, @post) and return
    end # if-else
  end # action publish
  
  # GET /admin/blogs/:blog_id/posts/:id
  def show; end
  
  # PUT /admin/blogs/:blog_id/posts/:id
  def update
    preprocess_tags
    
    if @post.update_attributes(params[:blog_post])
      append_flash :notice, "Post was successfully updated", true
      redirect_to admin_blog_post_path(@blog, @post)
    else
      render :edit
    end # if-else
  end # action update
  
  ###############
  # PREPROCESSING
  
  def preprocess_tags
    tags = (params[:blog_post][:tags] || []).split(",").map { |tag|
      Tag.find_by_title(tag.strip)
    }.compact
    
    params[:blog_post][:tags] = tags
  end # helper preprocess_tags
  private :preprocess_tags
  
  ################
  # HELPER METHODS
  
  def find_blog
    @blog = Blog.find(params[:blog_id])
  end # helper find_blog
  
  def build_post(attributes = nil)
    attributes ||= params[:blog_post]
    attributes[:author_id] ||= current_user.id if attributes
    
    @post = (@blog || find_blog).posts.build(attributes)
  end # helper build_post
  
  def find_post
    @post = (@blog || find_blog).posts.find(params[:id])
  end # helper find_post

  def find_post_collection
    @posts = (@blog || find_blog).posts
  end # helper find_post_collection
  private :find_blog, :build_post, :find_post, :find_post_collection
end # controller Admin::BlogPostsController
