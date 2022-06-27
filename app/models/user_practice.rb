class UserPractice < ApplicationRecord
  # used to tell if a user has committed to a practice
  belongs_to :user
  belongs_to :practice

  scope :favorited, -> { where(favorited: true) }
  scope :favorited_by_date_range, -> (start_date, end_date) { where(time_favorited: start_date..end_date) }
end
