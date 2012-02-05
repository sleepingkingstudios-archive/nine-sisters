class AddSlugToArticleVersion < ActiveRecord::Migration
  def change
    add_column :article_versions, :slug, :string
  end
end
