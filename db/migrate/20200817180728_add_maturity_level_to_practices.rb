class AddMaturityLevelToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :maturity_level, :integer
  end
end
