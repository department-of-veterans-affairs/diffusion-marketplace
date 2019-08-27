# frozen_string_literal: true

class AncillaryServicePractice < ApplicationRecord
  belongs_to :ancillary_service
  belongs_to :practice
end
