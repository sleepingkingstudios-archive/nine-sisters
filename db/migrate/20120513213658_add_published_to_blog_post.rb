class AddPublishedToBlogPost < ActiveRecord::Migration
  def change
    add_column :blog_posts, :published, :boolean
    add_column :blog_posts, :published_at, :datetime
  end
end
