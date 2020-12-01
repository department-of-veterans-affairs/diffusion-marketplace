class AddDatePublishedToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :date_published, :datetime, null: true
  end
end