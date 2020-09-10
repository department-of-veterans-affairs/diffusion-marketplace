class Milestone < ApplicationRecord
  acts_as_list scope: :timeline
  belongs_to :timeline
  default_scope { order(position: :asc) }
end
