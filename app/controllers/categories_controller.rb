class CategoriesController < ApplicationController
  before_filter :authenticate_user, :except => %w(index show)
  
  # GET /categories
  def index
    @categories = Category.all
  end # action index
  
  # GET /categories/new
  def new
    @category = Category.new params[:category]
  end # action new
  
  # GET /categories/:id
  # GET /categories/:slug
  def show
    if @category = Category.find_by_slug(params[:id])
      render and return
    elsif @category = Category.find(params[:id])
      redirect_to "/categories/#{@category.slug}" and return
    else
      redirect_to "/categories" and return
    end # if
  rescue ActiveRecord::RecordNotFound => error
    append_flash :error, "Couldn't find Category with title or id \"#{params[:id]}\".", true
    redirect_to "/categories" and return
  end # action show
end # controller CategoriesController