class AddLastEmailDateToPractices < ActiveRecord::Migration[6.1]
  def change
    add_column :practices, :last_email_date, :datetime, null: true
  end
end
