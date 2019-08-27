# frozen_string_literal: true

json.array! @va_employees, partial: 'va_employees/va_employee', as: :va_employee
