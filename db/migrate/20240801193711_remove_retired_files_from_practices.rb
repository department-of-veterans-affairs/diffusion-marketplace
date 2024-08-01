class RemoveRetiredFilesFromPractices < ActiveRecord::Migration[6.1]
  def change
    remove_column
  end

  def up
    remove_attachment :practices, :business_case_files
  end

  def down
    add_attachment :practices, :business_case_files
  end
end
