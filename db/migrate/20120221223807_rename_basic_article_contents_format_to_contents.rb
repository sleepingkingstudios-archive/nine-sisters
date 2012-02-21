class RenameBasicArticleContentsFormatToContents < ActiveRecord::Migration
  def change
    change_table :basic_articles do |table|
      table.rename :contents_format, :format
    end # change_table
  end # method change
end # migration RenameBasicArticleContentsFormatToContents
