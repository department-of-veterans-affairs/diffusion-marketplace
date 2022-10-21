class CreatePageEventComponent < ActiveRecord::Migration[6.0]
  def change
    create_table :page_event_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :title
      t.string :url
      t.string :text
      t.timestamps
    end
  end
end
