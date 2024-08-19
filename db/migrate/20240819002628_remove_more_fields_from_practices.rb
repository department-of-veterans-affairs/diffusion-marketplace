class RemoveMoreFieldsFromPractices < ActiveRecord::Migration[6.1]
  def change
    remove_column :practices, :need_additional_staff, :boolean
  end
end
