class RemoveHighlightFromPractices < ActiveRecord::Migration[6.1]
  def up
    remove_attachment :practices, :highlight_attachment
    remove_column :practices, :featured, :boolean
    remove_column :practices, :highlight, :boolean
    remove_column :practices, :highlight_body, :string
  end

  def down
    add_attachment :practices, :highlight_attachment
    add_column :practices, :featured, :boolean
    add_column :practices, :highlight, :boolean
    add_column :practices, :highlight_body, :string
  end
end
