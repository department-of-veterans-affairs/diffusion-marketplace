class Timeline < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice
  has_many :milestones, dependent: :destroy

  accepts_nested_attributes_for :milestones, allow_destroy: true, reject_if: proc { |attributes| attributes['description'].blank? }
end
