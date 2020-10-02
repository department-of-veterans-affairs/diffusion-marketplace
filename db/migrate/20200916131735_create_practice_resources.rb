class CreatePracticeResources < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_resources do |t|
      t.belongs_to :practice, foreign_key: true
      t.string :link_url
      t.string :resource
      t.string :name
      t.string :description
      t.integer :resource_type  # core, optional, support
      t.integer :media_type   # resource, file, link
      t.integer :resource_type_label # people, processes, tools
      t.integer :position
      t.timestamps
    end
    add_attachment :practice_resources, :attachment
  end
end