# frozen_string_literal: true

class Department < ApplicationRecord
  acts_as_list
  has_paper_trail
  has_many :department_practices
  has_many :practices, through: :department_practices
end
