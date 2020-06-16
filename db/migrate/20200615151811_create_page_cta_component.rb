class CreatePageCtaComponent < ActiveRecord::Migration[5.2]
  def change
    create_table :page_cta_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
        t.text :cta_text
        t.string :button_text
        t.string :url
        t.timestamps
    end
  end
end
