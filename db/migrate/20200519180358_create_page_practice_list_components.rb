class CreatePagePracticeListComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :page_practice_list_components do |t|
      t.string :practices, array: true, default: []

      t.timestamps
    end
  end
end
