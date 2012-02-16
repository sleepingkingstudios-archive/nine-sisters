class CreateCategoryFeatures < ActiveRecord::Migration
  def change
    create_table :category_features do |t|
      t.string :slug
      t.integer :category_id
      t.integer :feature_id
      t.string :feature_type

      t.timestamps
    end # create_table :category_features
  end # method change
end # migration CreateCategoryFeatures
