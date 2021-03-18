class ChangeVamcsToVaFacilities < ActiveRecord::Migration[5.2]
  def change
    rename_table :vamcs, :va_facilities
  end
end
