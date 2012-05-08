class Admin::BasicArticlesController < Admin::AdminController
  # GET /admin/basic_articles/:id
  def show
    @article = BasicArticle.find(params[:id])
  end # action show
end # controller Admin::BasicArticlesController
