class UpdateVaEmployeePracticesForPolymorphicAssociation < ActiveRecord::Migration[6.1]
  def change
    add_reference :va_employee_practices, :innovable, polymorphic: true, index: true

    execute <<-SQL
      UPDATE va_employee_practices
      SET innovable_id = practice_id, innovable_type = 'Practice'
      WHERE practice_id IS NOT NULL
    SQL

    remove_column :va_employee_practices, :practice_id
  end
end
