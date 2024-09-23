class DropRetiredImporterModels < ActiveRecord::Migration[6.1]
  def change
    drop_table :required_staff_trainings
    drop_table :costs
    drop_table :difficulties
  end
end
