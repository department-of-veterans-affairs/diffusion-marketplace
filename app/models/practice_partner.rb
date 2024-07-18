class PracticePartner < ApplicationRecord
  include ActiveModel::Dirty
  extend FriendlyId
  friendly_id :name, use: :slugged
  acts_as_list
  has_paper_trail
  has_many :practice_partner_practices, dependent: :destroy
  has_many :practices, through: :practice_partner_practices

  after_commit :clear_caches

  attr_accessor :reset_cached_practice_partners

  scope :major_partners, -> { where(is_major: true) }

  def self.cached_practice_partners
    Rails.cache.fetch('practice_partners') do
      PracticePartner.all.order(Arel.sql("lower(name) ASC")).load
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["description","name"]
  end

  private

  def clear_caches
    Rails.cache.delete('practice_partners')
    practices.each(&:clear_searchable_cache)
  end
end
