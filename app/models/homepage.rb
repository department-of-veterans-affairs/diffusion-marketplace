class Homepage < ApplicationRecord
  has_paper_trail
  has_many :homepage_features, dependent: :destroy
  accepts_nested_attributes_for :homepage_features, allow_destroy: true

  before_save :unpublish_other_homepages, if: :published?

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
end
