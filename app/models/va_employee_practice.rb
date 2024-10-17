class VaEmployeePractice < ApplicationRecord
  acts_as_list scope: :innovable
  belongs_to :innovable, polymorphic: true
  belongs_to :va_employee
end
