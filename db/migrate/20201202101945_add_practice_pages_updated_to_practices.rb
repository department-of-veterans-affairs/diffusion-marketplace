class AddPracticePagesUpdatedToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :practice_pages_updated, :datetime, null: true
  end
end