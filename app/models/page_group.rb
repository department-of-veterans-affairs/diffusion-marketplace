class PageGroup < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :pages, dependent: :destroy
  validates_uniqueness_of :name
  validates :name, presence: true
  validates :description, presence: true

  COMMUNITY_SLUGS = [
    'xr-network',
    'va-immersive'
  ]

  def is_community?
    COMMUNITY_SLUGS.include?(self.slug)
  end
end
