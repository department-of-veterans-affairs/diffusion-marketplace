class RiskMitigation < ApplicationRecord
  acts_as_list
  belongs_to :practice
  has_many :risks
  has_many :mitigations
end
