# frozen_string_literal: true

class ClinicalLocationPractice < ApplicationRecord
  belongs_to :clinical_location
  belongs_to :practice
end
