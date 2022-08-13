class CreateCommunityLeaders < ActiveRecord::Migration[6.0]
  def change
    create_table :community_leaders do |t|
      t.belongs_to :community, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.boolean :featured, default: false
      t.timestamps
    end
  end
end
