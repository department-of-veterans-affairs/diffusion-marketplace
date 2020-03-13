class Milestone < ApplicationRecord
  acts_as_list scope: :timeline
  belongs_to :timeline
end
