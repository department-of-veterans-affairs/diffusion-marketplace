class PageCompoundBodyComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
  has_many :page_component_images, dependent: :destroy
end