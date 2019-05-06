class Department < ApplicationRecord
  acts_as_list scope: :practice
  has_many :department_practices
  has_many :practices, through: :department_practices
end
