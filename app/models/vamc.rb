class Vamc < ApplicationRecord
  extend FriendlyId
  friendly_id :common_name, use: :slugged

  belongs_to :visn

  before_save :clear_vamc_cache_on_save
  after_save :reset_vamc_cache

  attr_accessor :reset_cached_vamcs

  def clear_vamc_cache
    Rails.cache.delete('vamcs')
  end

  def reset_vamc_cache
    clear_vamc_cache if self.reset_cached_vamcs
  end

  def clear_vamc_cache_on_save
    if self.changed?
      self.reset_cached_vamcs = true
    end
  end

  def self.cached_vamcs
    Rails.cache.fetch('vamcs') do
      Vamc.all
    end
  end
end