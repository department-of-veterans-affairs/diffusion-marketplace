class CreatePageNewsComponent < ActiveRecord::Migration[6.0]
  def change
    create_table :page_news_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :title
      t.string :url
      t.string :text
      t.date :published_date
    end
  end
end
