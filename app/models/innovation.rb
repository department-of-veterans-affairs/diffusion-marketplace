class Innovation < ApplicationRecord
  self.abstract_class = true
  has_paper_trail

  belongs_to :user, optional: true
end