class AddSlugLockToBlogPost < ActiveRecord::Migration
  def change
    add_column :blog_posts, :slug_lock, :boolean

  end
end
