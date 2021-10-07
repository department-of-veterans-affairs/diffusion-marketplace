class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.string :title
      t.string :description
      t.string :url
      t.string :cta_text
      t.boolean :featured, default: false, null: false
      t.timestamps
    end
    add_attachment :topics, :attachment
  end
end
