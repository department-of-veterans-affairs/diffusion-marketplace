class DropRetiredFileModels < ActiveRecord::Migration[6.1]
  def change
    drop_table :business_case_files
    drop_table :toolkit_files
    drop_table :publication_files
    drop_table :checklist_files
  end
end
