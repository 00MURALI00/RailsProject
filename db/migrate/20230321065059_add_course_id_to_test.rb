class AddCourseIdToTest < ActiveRecord::Migration[7.0]
  def change
    add_column :tests, :courseId, :integer
    add_index :tests, :courseId
  end
end
