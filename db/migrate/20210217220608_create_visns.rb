class CreateVisns < ActiveRecord::Migration[5.2]
  def change
    create_table :visns do |t|
      t.string :name
      t.integer :number
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.decimal :latitude, precision: 11, scale: 8
      t.decimal :longitude, precision: 11, scale: 8
      t.string :phone_number

      t.timestamps
    end
  end
end
