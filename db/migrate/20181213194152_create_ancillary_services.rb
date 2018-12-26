class CreateAncillaryServices < ActiveRecord::Migration[5.2]
  def change
    create_table :ancillary_services do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
