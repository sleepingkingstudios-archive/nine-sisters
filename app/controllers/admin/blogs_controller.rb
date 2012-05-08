class Admin::BlogsController < Admin::AdminController
  # GET /admin/blogs
  def index
    @blogs = Blog.all
  end # action index
  
  # GET /admin/blogs/:id
  def show
    @blog = Blog.find(params[:id])
    @posts = @blog.posts
  end # action show
end # controller BlogsController
