class RiskMitigation < ApplicationRecord
  acts_as_list
  belongs_to :practice
  has_many :risks, dependent: :destroy
  has_many :mitigations, dependent: :destroy

  accepts_nested_attributes_for :risks, allow_destroy: true
  accepts_nested_attributes_for :mitigations, allow_destroy: true
end
