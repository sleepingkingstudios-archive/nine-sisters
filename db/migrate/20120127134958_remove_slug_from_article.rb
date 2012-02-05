class RemoveSlugFromArticle < ActiveRecord::Migration
  def change
    change_table :articles do |table|
      table.remove :slug
    end # change_table
  end # method change
end # migration RemoveSlugFromArticle
