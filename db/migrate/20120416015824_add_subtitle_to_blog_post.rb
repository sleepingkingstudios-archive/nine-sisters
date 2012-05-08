class AddSubtitleToBlogPost < ActiveRecord::Migration
  def change
    add_column :blog_posts, :subtitle, :string

  end
end
