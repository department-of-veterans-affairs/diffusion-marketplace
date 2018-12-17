class CreateAncillaryServicePractices < ActiveRecord::Migration[5.2]
  def change
    create_table :ancillary_service_practices do |t|
      t.belongs_to :ancillary_service, foreign_key: true
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
