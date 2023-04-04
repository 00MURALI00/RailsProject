class AddPublishedAtToNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :published, :boolean
  end
end
