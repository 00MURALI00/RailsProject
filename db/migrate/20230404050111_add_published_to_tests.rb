class AddPublishedToTests < ActiveRecord::Migration[7.0]
  def change
    add_column :tests, :published, :boolean
  end
end
