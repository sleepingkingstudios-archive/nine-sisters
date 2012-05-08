class Admin::OldArticlesController < ApplicationController
  before_filter :authenticate_user
  
  # POST /admin/articles
  def create
    @article = Article.new params[:article]
    render :new unless @article.save
    
    @version = @article.versions.build params[:article_version]
    render :new unless @version.save
    
    append_flash :notice, "Article was successfully created", true
    redirect_to [:admin, @article]
  end # action create
  
  # DELETE /admin/articles/:id
  def destroy
    @article = Article.find params[:id]
    @article.destroy
    
    append_flash :warning, "Article was successfully deleted", true
    redirect_to admin_articles_url
  end # action destroy
  
  # GET /admin/articles/:id/edit
  def edit
    @article = Article.find params[:id]
    @categories = Category.all
    @version = @article.versions.last.dup
  end # action edit
  
  # GET /admin/articles
  def index
    @articles = Article.all
    @categories = Category.all
  end # action index
  
  # GET /admin/articles/new
  def new
    @article = Article.new params[:article]
    @categories = Category.all
    @version = @article.versions.build
  end # action new
  
  # PUT /admin/articles/:id/publish
  def publish
    @article = Article.find params[:id]
    @version = @article.versions.last
    @version.published = true
    if @article.save and @version.save
      append_flash :notice, "Article was successfully published", true
      redirect_to admin_article_path @article
    else
      append_flash :error, "Unable to publish article", true
      redirect_to edit_admin_article_path @article
    end # if-else
  end # action publish
  
  # PUT /admin/articles/:id/publish
  def revert
    @article = Article.find params[:id]
    @version = @article.versions.last
    @version.published = false
    if @article.save and @version.save
      if @article.published?
        append_flash :notice, "Article was reverted to previously published version", true
      else
        append_flash :notice, "Article was reverted to draft", true
      end # if-else
      redirect_to admin_article_path @article
    else
      append_flash :error, "Unable to revert article", true
      redirect_to edit_admin_article_path @article
    end # if-else
  end # action revert
  
  # GET /admin/articles/:id
  def show
    @article = Article.find(params[:id])
  rescue ActiveRecord::RecordNotFound => error
    error_message = error.message
  ensure
    unless @article
      append_flash :error, error_message || "Couldn't find article with id=#{params[:id]}", true
      redirect_to admin_articles_path
    end # unless
  end # action show
  
  # PUT /admin/articles/:id
  def update
    @article = Article.find params[:id]
    render :edit unless @article.save
    
    @version = @article.versions.build params[:article_version]
    render :new unless @version.save
    
    append_flash :notice, "Article was successfully updated", true
    redirect_to [:admin, @article]
  end # action update
end # controller Admin::OldArticlesController
