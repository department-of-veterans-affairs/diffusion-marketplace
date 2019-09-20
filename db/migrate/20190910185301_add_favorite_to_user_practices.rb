class AddFavoriteToUserPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :user_practices, :favorited, :boolean, default: false
  end
end
