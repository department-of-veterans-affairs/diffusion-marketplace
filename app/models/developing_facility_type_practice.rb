# frozen_string_literal: true

class DevelopingFacilityTypePractice < ApplicationRecord
  belongs_to :practice
  belongs_to :developing_facility_type
end
