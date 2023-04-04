class ChangePublishedToBeDateInNotes < ActiveRecord::Migration[7.0]
  def change
    change_column :notes, :published, :date
  end
end
