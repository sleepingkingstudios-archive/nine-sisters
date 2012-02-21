class AddSlugLockToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :slug_lock, :boolean
  end # method change
end # migration AddSlugLockToCategory
