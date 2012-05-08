class AddSlugLockToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :slug_lock, :boolean

  end
end
