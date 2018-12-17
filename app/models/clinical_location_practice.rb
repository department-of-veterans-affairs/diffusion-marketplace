class ClinicalLocationPractice < ApplicationRecord
  acts_as_list
  belongs_to :clinical_location
  belongs_to :practice
end
