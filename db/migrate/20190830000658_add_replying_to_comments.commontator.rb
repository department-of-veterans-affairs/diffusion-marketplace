# This migration comes from commontator (originally 1)
class AddReplyingToComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :commontator_comments, :parent, foreign_key: {
      to_table: :commontator_comments, on_update: :restrict, on_delete: :cascade
    }
  end
end
