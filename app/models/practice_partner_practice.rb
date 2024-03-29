class PracticePartnerPractice < ApplicationRecord
  include ActiveModel::Dirty
  belongs_to :practice_partner
  belongs_to :practice

  before_save :clear_searchable_practices_cache_on_save
  before_destroy :clear_searchable_practices_cache_on_destroy
  after_save :reset_searchable_practices_cache
  after_destroy :reset_searchable_practices_cache

  attr_accessor :reset_cached_searchable_practices

  scope :order_by_id, -> { order(id: :asc) }

  def clear_searchable_practices_cache
    cache_keys = ["searchable_practices_json", "searchable_public_practices_json"]
    cache_keys.each do |cache_key|
      Cache.new.delete_cache_key(cache_key)
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
