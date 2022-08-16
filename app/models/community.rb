class Community < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :community_practices, dependent: :destroy
  has_many :community_leaders, dependent: :destroy
  has_many :community_faqs, dependent: :destroy
  has_many :practices, through: :community_practices
  has_many :users, through: :community_leaders
end
