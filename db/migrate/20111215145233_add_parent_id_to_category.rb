class AddParentIdToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :parent_id, :integer
  end # method change
end # migration AddParentIdToCategory
