class ChangeColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :notes, :published, :published_at
  end
end
