class UserPractice < ApplicationRecord
  # used to tell if a user has committed to a practice
  belongs_to :user
  belongs_to :practice

  scope :favorited, -> { where(favorited: true) }
  scope :favorited_by_date_range, -> (start_date, end_date) { where(time_favorited: start_date..end_date) }
  scope :get_by_practice, -> (practice_id) { where(practice_id: practice_id) }
  scope :get_by_practice_and_favorited, -> (practice_id) { get_by_practice(practice_id).favorited }
  scope :get_by_practice_and_favorited_date_range, -> (practice_id, start_date, end_date) {
    get_by_practice(practice_id).favorited_by_date_range(start_date, end_date)
  }
end
