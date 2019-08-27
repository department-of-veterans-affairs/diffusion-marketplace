# frozen_string_literal: true

class PracticePermission < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice
end
