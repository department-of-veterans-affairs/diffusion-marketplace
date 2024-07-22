class RemoveAvatarFromVaEmployees < ActiveRecord::Migration[6.1]
  def up
    remove_attachment :va_employees, :avatar
  end

  def down
    add_attachment :va_employees, :avatar
  end
end
