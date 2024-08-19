class DropRetiredFileModels < ActiveRecord::Migration[6.1]
  def change
    drop_table :business_case_files
    drop_table :toolkit_files
  end
end
