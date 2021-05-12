class AddIndexToVaFacilitiesAndVisnLiaisons < ActiveRecord::Migration[5.2]
  def change
    add_index :va_facilities, :station_number, unique: true
    add_index :visn_liaisons, :email, unique: true
  end
end
