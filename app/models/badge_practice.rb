# frozen_string_literal: true

class BadgePractice < ApplicationRecord
  belongs_to :badge
  belongs_to :practice
end
