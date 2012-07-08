class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :slug
      t.boolean :slug_lock

      t.timestamps
    end
  end
end
