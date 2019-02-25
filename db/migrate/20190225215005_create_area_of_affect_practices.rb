class CreateAreaOfAffectPractices < ActiveRecord::Migration[5.2]
  def change
    create_table :area_of_affect_practices do |t|
      t.belongs_to :practice, foreign_key: true
      t.belongs_to :area_of_affect, foreign_key: true

      t.timestamps
    end
  end
end
