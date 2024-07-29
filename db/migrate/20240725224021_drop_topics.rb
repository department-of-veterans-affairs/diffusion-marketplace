class DropTopics < ActiveRecord::Migration[6.1]
  def change
    drop_table :topics
  end
end
