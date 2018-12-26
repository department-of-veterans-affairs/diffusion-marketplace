class CreateBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :badges do |t|
      t.string :name
      t.string :short_name
      t.text :description
      t.integer :position
      t.belongs_to :strategic_sponsor, foreign_key: true

      t.timestamps
    end

    add_attachment :badges, :badge_image
  end
end
