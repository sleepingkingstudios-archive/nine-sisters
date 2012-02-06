class ArticlesController < ApplicationController
  # GET /articles/:id
  def show
    @article = (article = Article.find(params[:id])).published? ? article : nil
    @categories = article.categories.reverse
  rescue ActiveRecord::RecordNotFound => error
    error_message = error.message
  ensure
    unless @article
      append_flash :error, error_message || "Couldn't find article with id=#{params[:id]}", true
      redirect_to :root
    end # unless
  end # method show
end # controller ArticlesController
