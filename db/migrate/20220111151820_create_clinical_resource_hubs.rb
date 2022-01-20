class CreateClinicalResourceHubs < ActiveRecord::Migration[5.2]
  def change
    create_table :clinical_resource_hubs do |t|
      t.belongs_to :visn, foreign_key: true
      t.string :name
      t.timestamps
    end
  end
end