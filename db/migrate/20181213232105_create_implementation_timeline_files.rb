class CreateImplementationTimelineFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :implementation_timeline_files do |t|
      t.string :title
      t.integer :position
      t.text :description
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end

    add_attachment :implementation_timeline_files, :attachment
  end
end
