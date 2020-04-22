class AddFavoriteAndCommittedTimeStampsToUserPractice < ActiveRecord::Migration[5.2]
  def change
    add_column :user_practices, :time_favorited, :datetime
    add_column :user_practices, :time_committed, :datetime
  end
end
