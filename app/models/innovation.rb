class Innovation < ApplicationRecord
  self.abstract_class = true
  has_paper_trail

  belongs_to :user, optional: true
  has_many :category_practices, as: :innovable, dependent: :destroy, autosave: true
  has_many :categories, through: :category_practices
end