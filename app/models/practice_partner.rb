class PracticePartner < ApplicationRecord
  include ActiveModel::Dirty
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_list
  has_paper_trail
  has_many :badges
  has_many :practice_partner_practices, dependent: :destroy
  has_many :practices, through: :practice_partner_practices

  before_save :clear_practice_partners_cache_on_save
  before_destroy :clear_practice_partners_cache_on_destroy
  after_save :reset_practice_partners_cache
  after_destroy :reset_practice_partners_cache

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

  def clear_practice_partners_cache_on_destroy
    self.reset_cached_practice_partners = true
  end

  def self.cached_practice_partners
    Rails.cache.fetch('practice_partners') do
      PracticePartner.all.order(Arel.sql("lower(name) ASC")).load
    end
  end
end
