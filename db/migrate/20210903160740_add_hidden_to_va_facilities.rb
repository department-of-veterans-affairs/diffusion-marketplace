class AddHiddenToVaFacilities < ActiveRecord::Migration[5.2]
  def change
    add_column :va_facilities, :hidden, :boolean, null: false, default: false
  end
end