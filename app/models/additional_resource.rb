# frozen_string_literal: true

class AdditionalResource < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice
end
