class CreateUserPractices < ActiveRecord::Migration[5.2]
  def change
    create_table :user_practices do |t|
      t.belongs_to :user
      t.belongs_to :practice, foreign_key: true
      t.boolean :committed

      t.timestamps
    end
  end
end
