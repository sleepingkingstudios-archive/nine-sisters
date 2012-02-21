class CreateBasicArticles < ActiveRecord::Migration
  def change
    create_table :basic_articles do |t|
      t.string :title
      t.string :slug
      t.boolean :slug_lock
      t.text :contents
      t.string :contents_format

      t.timestamps
    end
  end
end
