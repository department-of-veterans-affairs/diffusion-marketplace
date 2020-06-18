class AddEverPublishedToPages  < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :ever_published, :boolean, null: false, default: false
  end
end