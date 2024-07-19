class VaEmployee < ApplicationRecord
  acts_as_list
  has_paper_trail

  has_many :va_employee_practices
  has_many :practices, through: :va_employee_practices

  private

end
