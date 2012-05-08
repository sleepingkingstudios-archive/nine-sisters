class BlogsController < ApplicationController
  # GET /blog
  # GET /blogs/:id
  def show
    @blog = Blog.find(params[:id])
  end # action show
end # controller BlogsController
