class AddPublishedToPages  < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :published, :datetime, null: true
  end
end