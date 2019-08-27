# frozen_string_literal: true

class Difficulty < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice
end
