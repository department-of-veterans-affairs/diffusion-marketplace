class CreateAdditionalResources < ActiveRecord::Migration[5.2]
  def change
    create_table :additional_resources do |t|
      t.text :description
      t.integer :position
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
