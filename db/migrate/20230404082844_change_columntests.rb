class ChangeColumntests < ActiveRecord::Migration[7.0]
  def change
    rename_column :tests, :published, :published_at
  end
end
