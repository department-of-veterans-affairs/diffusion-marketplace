# frozen_string_literal: true

class Mitigation < ApplicationRecord
  acts_as_list scope: :risk_mitigation
  belongs_to :risk_mitigation
end
