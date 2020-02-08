class AdditionalStaff < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice

    # validates :title, :hours_per_week, :duration_in_weeks, presence: true
end
