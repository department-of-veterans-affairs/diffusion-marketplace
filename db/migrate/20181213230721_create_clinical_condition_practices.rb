class CreateClinicalConditionPractices < ActiveRecord::Migration[5.2]
  def change
    create_table :clinical_condition_practices do |t|
      t.belongs_to :clinical_condition, foreign_key: true
      t.belongs_to :practice, foreign_key: true

      t.timestamps
    end
  end
end
