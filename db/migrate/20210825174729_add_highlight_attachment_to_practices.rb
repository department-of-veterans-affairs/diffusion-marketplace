class AddHighlightAttachmentToPractices < ActiveRecord::Migration[5.2]
  def change
    add_attachment :practices, :highlight_attachment
  end
end
