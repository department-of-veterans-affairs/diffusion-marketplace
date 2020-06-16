class AddInitiatingFacilityOtherToPractices  < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :initiating_facility_other, :string
  end
end