class CreatePageBlockQuoteComponent < ActiveRecord::Migration[6.0]
  def change
    create_table :page_block_quote_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.text :text
      t.text :citation
      t.timestamps
    end
  end
end
