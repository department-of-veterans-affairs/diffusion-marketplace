class CreatePracticeEditorSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_editor_sessions do |t|
      t.belongs_to :user
      t.belongs_to :practice, foreign_key: true
      t.datetime :session_start_time
      t.datetime :session_end_time
      t.timestamps
    end
  end
end