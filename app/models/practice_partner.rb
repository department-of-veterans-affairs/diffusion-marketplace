class PracticePartner < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_list
  has_many :badges
  has_many :practice_partner_practices, dependent: :destroy
  has_many :practices, through: :practice_partner_practices

end
