class AreaOfAffect < ApplicationRecord
  has_many :area_of_affect_practices
  has_many :practices, through: :area_of_affect_practices
end
