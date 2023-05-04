class AddColumnToNote < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :course_id, :integer
  end
end
