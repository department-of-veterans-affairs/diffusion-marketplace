class Page < ApplicationRecord
  belongs_to :page_group
  has_many :page_components, -> {order(position: :asc)}, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :page_components, allow_destroy: true

  validates_uniqueness_of :slug
end
