# frozen_string_literal: true

class PracticeManagementPractice < ApplicationRecord
  belongs_to :practice
  belongs_to :practice_management
end
