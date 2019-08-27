# frozen_string_literal: true

class PracticePartnerPractice < ApplicationRecord
  belongs_to :practice_partner
  belongs_to :practice
end
