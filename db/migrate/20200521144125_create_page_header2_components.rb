class CreatePageHeader2Components < ActiveRecord::Migration[5.2]
  def change
    create_table :page_header2_components do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :subtopic_title
      t.string :subtopic_description
      t.timestamps
    end
  end
end