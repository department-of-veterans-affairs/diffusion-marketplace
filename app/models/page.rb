class Page < ApplicationRecord
  belongs_to :page_category
  has_many :page_components, dependent: :destroy
  accepts_nested_attributes_for :page_components, allow_destroy: true
end
