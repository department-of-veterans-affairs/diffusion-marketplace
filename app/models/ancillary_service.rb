class AncillaryService < ApplicationRecord
  acts_as_list
  has_many :practices, through: :ancillary_service_practices
end
