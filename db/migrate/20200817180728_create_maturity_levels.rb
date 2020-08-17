class CreateMaturityLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :maturity_levels do |t|
      t.string :name
      t.string :short_name
      t.text :definition
      t.integer :position

      t.timestamps
    end
  end
end
