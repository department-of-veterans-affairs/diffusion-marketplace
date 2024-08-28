class VaEmployeePractice < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :innovable, polymorphic: true
  belongs_to :va_employee
end
