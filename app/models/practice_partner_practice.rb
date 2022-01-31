class PracticePartnerPractice < ApplicationRecord
  include ActiveModel::Dirty
  belongs_to :practice_partner
  belongs_to :practice

  before_save :clear_searchable_practices_cache_on_save
  before_destroy :clear_searchable_practices_cache_on_destroy
  after_save :reset_searchable_practices_cache
  after_destroy :reset_searchable_practices_cache

  attr_accessor :reset_cached_searchable_practices

  def clear_searchable_practices_cache
    cache_keys = ["searchable_practices", "searchable_public_practices", "searchable_practices_json", "searchable_public_practices_json"]
    cache_keys.each do |cache_key|
      Rails.cache.delete(cache_key)
    end
  end

  def clear_searchable_practices_cache_on_save
    if self.changed?
      self.reset_cached_searchable_practices = true
    end
  end

  def clear_searchable_practices_cache_on_destroy
    self.reset_cached_searchable_practices = true
  end

  def reset_searchable_practices_cache
    clear_searchable_practices_cache if self.reset_cached_searchable_practices
  end
end
