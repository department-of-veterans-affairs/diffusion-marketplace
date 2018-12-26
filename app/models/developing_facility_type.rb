class DevelopingFacilityType < ApplicationRecord
  acts_as_list
  has_many :developing_facility_type_practices
  has_many :practices, through: :developing_facility_type_practices
end
