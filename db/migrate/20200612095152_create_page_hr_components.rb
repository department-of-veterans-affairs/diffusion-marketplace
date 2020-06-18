class CreatePageHrComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :page_hr_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :html_tag
      t.timestamps
    end
  end
end