class Timeline < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice

    #accepts_nested_attributes_for :milestones, allow_destroy: true
end
