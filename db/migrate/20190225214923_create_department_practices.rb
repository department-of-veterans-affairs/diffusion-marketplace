class CreateDepartmentPractices < ActiveRecord::Migration[5.2]
  def change
    create_table :department_practices do |t|
      t.belongs_to :practice, foreign_key: true
      t.belongs_to :department, foreign_key: true
      t.boolean :is_primary, default: false

      t.timestamps
    end
  end
end
