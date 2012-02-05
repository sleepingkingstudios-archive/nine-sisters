class CreateArticleVersions < ActiveRecord::Migration
  def change
    create_table :article_versions do |t|
      t.string :title
      t.string :format
      t.text :contents
      t.boolean :is_published
      t.integer :article_id
      t.integer :user_id

      t.timestamps
    end
  end
end
