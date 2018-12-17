class VaSecretaryPriorityPractice < ApplicationRecord
  acts_as_list
  belongs_to :va_secretary_priority
  belongs_to :practice
end
