class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.integer :blog_id
      t.string :title
      t.string :slug
      t.text :contents
      t.string :format

      t.timestamps
    end
  end
end
