# frozen_string_literal: true

class UserPractice < ApplicationRecord
  # used to tell if a user has committed to a practice
  belongs_to :user
  belongs_to :practice
end
