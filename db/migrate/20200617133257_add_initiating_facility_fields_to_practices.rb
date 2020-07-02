class AddInitiatingFacilityFieldsToPractices  < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :initiating_facility_type, :integer, default: 0
    add_column :practices, :initiating_department_office_id, :integer, null: true
  end
end