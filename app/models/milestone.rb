class Milestone < ApplicationRecord
  acts_as_list scope: :timeline
  default_scope { order(position: :asc) }
end
