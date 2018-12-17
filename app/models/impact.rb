class Impact < ApplicationRecord
  acts_as_list
  has_many :practices, through: :impact_practices
  belongs_to :impact_category
end
