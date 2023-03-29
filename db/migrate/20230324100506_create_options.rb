class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options do |t|
      t.string :opt1
      t.string :opt2
      t.string :opt3
      t.string :opt4

      t.timestamps
    end
  end
end
