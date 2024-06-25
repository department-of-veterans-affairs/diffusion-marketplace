class PracticePartnerPractice < ApplicationRecord
  include ActiveModel::Dirty
  belongs_to :practice_partner
  belongs_to :practice

  after_commit :clear_caches

  scope :order_by_id, -> { order(id: :asc) }

  private

  def clear_caches
    Rails.cache.delete("searchable_practices_json")
    Rails.cache.delete("searchable_public_practices_json")
    practice.clear_searchable_cache
  end
end
