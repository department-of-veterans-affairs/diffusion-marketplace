class ClinicalLocation < ApplicationRecord
  acts_as_list
  has_many :clinical_location_practices
  has_many :practices, through: :clinical_location_practices
end
