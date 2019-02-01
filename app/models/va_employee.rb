class VaEmployee < ApplicationRecord
  acts_as_list
  has_attached_file :avatar
  do_not_validate_attachment_file_type :avatar

  has_many :va_employee_practices
  has_many :practices, through: :va_employee_practices
end
