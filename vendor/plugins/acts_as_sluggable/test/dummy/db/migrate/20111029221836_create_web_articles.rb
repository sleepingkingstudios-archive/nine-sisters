class CreateWebArticles < ActiveRecord::Migration
  def change
    create_table :web_articles do |t|
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
