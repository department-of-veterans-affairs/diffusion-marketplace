class CreatePageDownloadableFileComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :page_downloadable_file_components, id: :uuid do |t|
      t.belongs_to :page_component, foreign_key: true
      t.string :display_name
      t.text :description
      t.timestamps
    end

    add_attachment :page_downloadable_file_components, :attachment
  end
end
