class RenameTagNameToTitle < ActiveRecord::Migration
  def change
    rename_column :tags, :name, :title
  end
end
