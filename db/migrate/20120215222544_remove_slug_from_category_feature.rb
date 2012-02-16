class RemoveSlugFromCategoryFeature < ActiveRecord::Migration
  def up
    change_table :category_features do |t|
      t.remove :slug
    end # change_table :category_features
  end # method up

  def down
    change_table :category_features do |t|
      t.string :slug
    end # change_table :category_features
  end # method down
end # migration RemoveSlugFromCategoryFeature
