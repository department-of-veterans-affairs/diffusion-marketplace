class CreatePracticeMultimedia < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_multimedia do |t|
      t.belongs_to :practice, foreign_key: true
      t.string :link_url
      t.timestamps
    end
    add_attachment :practice_multimedia, :attachment
  end
end