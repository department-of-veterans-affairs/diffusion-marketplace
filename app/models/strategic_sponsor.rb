class StrategicSponsor < ApplicationRecord
  acts_as_list
  has_many :badges
  has_many :strategic_sponsor_practices
  has_many :practices, through: :strategic_sponsor_practices

end
