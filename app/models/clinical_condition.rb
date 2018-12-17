class ClinicalCondition < ApplicationRecord
  acts_as_list
  has_many :practices, through: :clinical_condition_practices
end
