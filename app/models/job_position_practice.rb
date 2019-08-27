# frozen_string_literal: true

class JobPositionPractice < ApplicationRecord
  belongs_to :job_position
  belongs_to :practice
end
