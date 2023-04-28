class AddColumnToTestresult < ActiveRecord::Migration[7.0]
  def change
    add_column :testresults, :attempt_no, :integer
  end
end
