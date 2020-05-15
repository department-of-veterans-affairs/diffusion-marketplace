class PageGroup < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :pages
  validates_uniqueness_of :name
end
