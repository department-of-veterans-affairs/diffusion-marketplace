class CreatePracticeEditors < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_editors do |t|
      t.belongs_to :practice, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.datetime :invited_at, null: true
      t.datetime :accepted_at, null: true
      t.datetime :last_edited_at, null: true
      t.string :email
      t.integer :position

      t.timestamps
    end
  end
end
