# frozen_string_literal: true

class VaEmployeePractice < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice
  belongs_to :va_employee
end
