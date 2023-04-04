class ChangePublishedToBeDateInTest < ActiveRecord::Migration[7.0]
  def change
    change_column :tests, :published, :date
  end
end
