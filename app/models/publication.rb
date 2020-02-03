class Publication < ApplicationRecord
  acts_as_list scope: :practice
  belongs_to :practice

  validates :title, :link, presence: true
end
