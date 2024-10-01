class Homepage < ApplicationRecord
  has_many :homepage_features, dependent: :destroy
  accepts_nested_attributes_for :homepage_features, allow_destroy: true

  before_save :unpublish_other_homepages, if: :published?
  after_save :conditionally_clear_cache

  scope :published, -> { where(published: true) }

  def unpublish_other_homepages
    # Unpublish all other homepages with published: true
    Homepage.where(published: true).where.not(id: self.id).update_all(published: false)
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.ransackable_attributes(auth_object = nil)
    []
  end

  def self.current
    published.includes(:homepage_features).last
  end

  private

  def conditionally_clear_cache
    # Check if this instance is the currently published one
    if self.published? && self == Homepage.current
      Rails.cache.delete("homepage_with_features")
    # Check if this instance was just changed to published:true
    elsif saved_change_to_attribute?(:published, from: false, to: true)
      Rails.cache.delete("homepage_with_features")
    end
  end
end
