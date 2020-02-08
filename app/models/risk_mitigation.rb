class RiskMitigation < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice
  has_many :risks, dependent: :destroy
  has_many :mitigations, dependent: :destroy

  accepts_nested_attributes_for :risks, allow_destroy: true, reject_if: proc { |attributes| attributes['description'].blank? }
  accepts_nested_attributes_for :mitigations, allow_destroy: true, reject_if: proc { |attributes| attributes['description'].blank? }
end
