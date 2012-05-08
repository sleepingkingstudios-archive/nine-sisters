class AddSummaryToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :summary, :text

  end
end
