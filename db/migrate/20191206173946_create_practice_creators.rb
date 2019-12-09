class CreatePracticeCreators < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_creators do |t|
      t.belongs_to :practice, foreign_key: true
      t.references :user, foreign_key: true
      t.string :role
      t.string :name
      t.integer :position

      t.timestamps
    end

    add_attachment :practice_creators, :avatar
  end
end
