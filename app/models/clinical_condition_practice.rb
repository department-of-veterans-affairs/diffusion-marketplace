class ClinicalConditionPractice < ApplicationRecord
  belongs_to :clinical_condition
  belongs_to :practice
end
