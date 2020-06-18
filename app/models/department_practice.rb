class DepartmentPractice < ApplicationRecord
  belongs_to :practice
  belongs_to :department

  after_save :update_number_of_departments
  after_destroy :update_number_of_departments

  def departments_count
    self.practice.departments.where.not(name: 'None').count
  end

  def update_number_of_departments
    self.practice.update_attributes(number_departments: departments_count)
  end
end
