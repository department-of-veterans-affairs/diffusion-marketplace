# frozen_string_literal: true

class Cost < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice
end
