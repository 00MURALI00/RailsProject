class AddNameToTest < ActiveRecord::Migration[7.0]
  def change
    add_column :tests, :name, :string
  end
end
