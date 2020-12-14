class AddHighlightAttributesToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :highlight_title, :string
    add_column :practices, :highlight_body, :string
  end
end
