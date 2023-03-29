class RenameTestToCourseId < ActiveRecord::Migration[7.0]
  def change
    rename_column :tests, :courseId, :course_id
  end
end
