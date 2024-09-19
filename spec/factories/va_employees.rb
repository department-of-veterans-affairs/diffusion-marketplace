FactoryBot.define do
  factory :va_employee do
    sequence(:name) { |n| "Employee Name #{n}" }
    sequence(:role) { |n| "Role #{n}" }
  end
end