# frozen_string_literal: true

class CreateCreateStudentCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses_students, id: false do |t|
      t.belongs_to :student
      t.belongs_to :course

      t.timestamps
    end
  end
end
