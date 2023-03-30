class CreateTeachers < ActiveRecord::Migration[7.0]
  def change
    create_table :teachers do |t|
      t.string :name
      t.integer :age
      t.string :gender

      t.timestamps
    end
  end
end
