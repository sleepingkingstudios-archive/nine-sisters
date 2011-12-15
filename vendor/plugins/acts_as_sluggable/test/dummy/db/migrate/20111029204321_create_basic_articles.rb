class CreateBasicArticles < ActiveRecord::Migration
  def change
    create_table :basic_articles do |t|
      t.string :title
      t.string :slug

      t.timestamps
    end
  end
end
