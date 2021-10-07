class AddHighlightAttachmentToAndRemoveHighlightTitleFromPractices < ActiveRecord::Migration[5.2]
  def change
    add_attachment :practices, :highlight_attachment
    remove_column :practices, :highlight_title
  end
end
