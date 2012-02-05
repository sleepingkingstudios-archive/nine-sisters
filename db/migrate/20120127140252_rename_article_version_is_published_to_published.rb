class RenameArticleVersionIsPublishedToPublished < ActiveRecord::Migration
  def change
    change_table :article_versions do |table|
      table.rename :is_published, :published
    end # change_table
  end # method change
end # migration RenameArticleVersionIsPublishedToPublished
