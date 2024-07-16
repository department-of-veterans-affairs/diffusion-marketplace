class ChangeVaEmployees < ActiveRecord::Migration[6.1]
  def change
    remove_column :va_employees, :prefix, :string
    remove_column :va_employees, :suffix, :string
    remove_column :va_employees, :email, :string
    remove_column :va_employees, :bio, :text
    remove_column :va_employees, :job_title, :string
  end
end
