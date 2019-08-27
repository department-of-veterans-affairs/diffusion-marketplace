# frozen_string_literal: true

class VaSecretaryPriority < ApplicationRecord
  acts_as_list
  has_many :va_secretary_priority_practices
  has_many :practices, through: :va_secretary_priority_practices
end
