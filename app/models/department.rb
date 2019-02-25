class Department < ApplicationRecord
  has_many :department_practices
  has_many :practices, through: :department_practices
end
