class AddProcessIdToPracticeEditorSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :practice_editor_sessions, :process_id, :bigint, null: true
  end
end