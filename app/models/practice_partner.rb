class PracticePartner < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_list
  has_paper_trail
  has_many :badges
  has_many :practice_partner_practices, dependent: :destroy
  has_many :practices, through: :practice_partner_practices
  before_save :clear_practice_partners_cache_on_save
  after_save :reset_practice_partners_cache

  attr_accessor :no_practice_partners
  attr_accessor :reset_cached_practice_partners

  def clear_practice_partners_cache
    Rails.cache.delete('practice_partners')
  end

  def reset_practice_partners_cache
    clear_practice_partners_cache if self.reset_cached_practice_partners
  end

  def clear_practice_partners_cache_on_save
    if self.changed?
      self.reset_cached_practice_partners = true
    end
  end

  def self.cached_practice_partners
    Rails.cache.fetch('practice_partners') do
      PracticePartner.all.order(Arel.sql("lower(name) ASC"))
    end
  end
end
