class AdditionalResource < ApplicationRecord
  acts_as_list
  belongs_to :practice
end
