class Innovation < ApplicationRecord
  self.abstract_class = true
  has_paper_trail

  belongs_to :user, optional: true
  has_many :category_practices, as: :innovable, dependent: :destroy, autosave: true
  has_many :categories, through: :category_practices
  has_many :va_employee_practices, as: :innovable, dependent: :destroy
  has_many :va_employees, -> { order(position: :asc) }, through: :va_employee_practices
  has_many :practice_multimedia, -> { order(id: :asc) }, as: :innovable, dependent: :destroy
  has_many :practice_partner_practices, as: :innovable, dependent: :destroy
  has_many :practice_partners, through: :practice_partner_practices
end
