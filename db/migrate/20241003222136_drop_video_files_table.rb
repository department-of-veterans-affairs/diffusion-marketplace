class DropVideoFilesTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :video_files
  end
end
