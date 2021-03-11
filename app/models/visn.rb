class Visn < ApplicationRecord
  has_many :vamcs, dependent: :destroy

  before_save :clear_visn_cache_on_save
  after_save :reset_visn_cache

  attr_accessor :reset_cached_visns

  # Add a custom friendly URL that uses the visn number and not the id
  def to_param
    number.to_s
  end

  def clear_visn_cache
    Rails.cache.delete('visns')
  end

  def reset_visn_cache
    clear_visn_cache if self.reset_cached_visns
  end

  def clear_visn_cache_on_save
    if self.changed?
      self.reset_cached_visns = true
    end
  end

  def self.cached_visns
    Rails.cache.fetch('visns') do
      Visn.all
    end
  end
end