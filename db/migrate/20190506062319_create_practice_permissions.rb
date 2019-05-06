class CreatePracticePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_permissions do |t|
      t.integer :position
      t.string :description
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
