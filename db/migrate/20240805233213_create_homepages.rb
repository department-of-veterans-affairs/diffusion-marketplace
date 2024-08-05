class CreateHomepages < ActiveRecord::Migration[6.1]
  def change
    create_table :homepages do |t|
      t.string :section_title_one
      t.string :section_title_two
      t.string :section_title_three

      t.timestamps
    end
  end
end
