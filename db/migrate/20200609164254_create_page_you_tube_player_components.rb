class CreatePageYouTubePlayerComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :page_you_tube_player_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :url
      t.string :caption
      t.timestamps
    end
  end
end
