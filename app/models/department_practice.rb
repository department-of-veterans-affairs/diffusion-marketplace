# frozen_string_literal: true

class DepartmentPractice < ApplicationRecord
  belongs_to :practice
  belongs_to :department
end
