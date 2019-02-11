class AddUserAndPublishToPractice < ActiveRecord::Migration[5.2]
  def change
    add_reference :practices, :user, foreign_key: true
    add_column :practices, :published, :boolean, default: false
    add_column :practices, :approved, :boolean, default: false
  end
end
