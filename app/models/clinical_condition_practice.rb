class ClinicalConditionPractice < ApplicationRecord
  acts_as_list
  belongs_to :clinical_condition
  belongs_to :practice
end
