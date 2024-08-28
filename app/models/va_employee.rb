class VaEmployee < ApplicationRecord
  acts_as_list
  has_paper_trail

  has_many :va_employee_practices, as: :innovable, dependent: :destroy
  has_many :practices, through: :va_employee_practices, source: :innovable, source_type: 'Practice'
  has_many :products, through: :va_employee_practices, source: :innovable, source_type: 'Product'
end
