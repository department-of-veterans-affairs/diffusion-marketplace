class AdditionalStaff < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice
end
