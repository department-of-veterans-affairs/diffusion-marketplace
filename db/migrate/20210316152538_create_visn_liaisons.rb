class CreateVisnLiaisons < ActiveRecord::Migration[5.2]
  def change
    create_table :visn_liaisons do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :primary, default: false
      t.belongs_to :visn, foreign_key: true

      t.timestamps
    end
  end
end
