# frozen_string_literal: true

class DomainPractice < ApplicationRecord
  belongs_to :domain
  belongs_to :practice
end
