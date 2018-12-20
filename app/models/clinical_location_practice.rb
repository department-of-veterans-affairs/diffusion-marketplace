class ClinicalLocationPractice < ApplicationRecord
  belongs_to :clinical_location
  belongs_to :practice
end
