class Admin::CategoriesController < ApplicationController
  before_filter :authenticate_user
  
  # POST /admin/categories
  def create
    @category = Category.new params[:category]
    if @category.save
      append_flash :notice, "Category \"#{@category.title}\" was successfully created", true
      redirect_to admin_category_path @category
    else
      append_flash :error, "There was an error creating this category", true
      render :new
    end # if-else
  end # action create
  
  # DELETE /admin/categories/:id
  def destroy
    @category = Category.find params[:id]
    @category.destroy
    
    append_flash :warning, "Category was successfully deleted", true
    redirect_to admin_categories_url
  end # action destroy
  
  # GET /admin/articles/:id/edit
  def edit
    if (value = find_category(params[:id])).is_a? Category
      @category = value
      render and return
    else
      append_flash :error, value, true
      redirect_to admin_categories_url and return
    end # if-else
  end # action edit
  
  # GET /admin/categories
  def index
    @categories = Category.all
  end # action index
  
  # GET /admin/categories/new
  def new
    @category = Category.new params[:category]
  end # action new
  
  # GET /admin/categories/:id
  # GET /admin/categories/:slug
  def show
    if (value = find_category(params[:id])).is_a? Category
      @category = value
      render and return
    else
      append_flash :error, value, true
      redirect_to admin_categories_url and return
    end # if-else
  end # action show
  
  # PUT /admin/categories/:id
  def update
    if (value = find_category(params[:id])).is_a? Category
      render :edit unless (@category = value).update_attributes params[:category]
      
      append_flash :notice, "Category was successfully updated", true
      redirect_to admin_category_url(@category)
    else
      append_flash :error, value, true
      redirect_to admin_categories_url and return
    end # if-else
  end # action update
  
  def find_category(identifier)
    # if identifier is an integer, try Category.find()
    if identifier =~ /^\d+$/
      return Category.find(identifier)
    end # if
    return "Couldn't find Category with identifier=\"#{identifier}\""
  rescue ActiveRecord::RecordNotFound => error
    return error.to_s
  end # helper find_category
  private :find_category
end # controller Admin::CategoriesController
