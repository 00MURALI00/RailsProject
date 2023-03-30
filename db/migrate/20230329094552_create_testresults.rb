# frozen_string_literal: true
class CreateTestresults < ActiveRecord::Migration[7.0]
  def change
    create_table :testresults do |t|
      t.integer :test_id
      t.integer :student_id
      t.integer :score

      t.timestamps
    end
  end
end
