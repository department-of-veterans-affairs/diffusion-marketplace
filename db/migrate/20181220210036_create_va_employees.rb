class CreateVaEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :va_employees do |t|
      t.string :name
      t.string :prefix
      t.string :suffix

      t.string :email
      t.text :bio

      t.string :job_title

      t.integer :position

      t.timestamps
    end
  end
end
