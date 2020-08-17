class MaturityLevel < ApplicationRecord
  has_paper_trail
  has_many :maturity_level_practices, dependent: :destroy
  has_many :practices, through: :maturity_level_practices
end
