class AddPublishedAndRetiredToProducts < ActiveRecord::Migration[6.1]
  def change
    change_column_default :products, :published, from: nil, to: false
    add_column :products, :date_published, :datetime
    add_column :products, :retired, :boolean, default: false, null: false
  end
end
