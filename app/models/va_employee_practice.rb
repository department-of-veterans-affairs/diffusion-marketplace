class VaEmployeePractice < ApplicationRecord
  acts_as_list
  belongs_to :practice
  belongs_to :va_employee
end
