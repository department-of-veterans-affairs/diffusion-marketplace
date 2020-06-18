class PageCtaComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
  validates :cta_text, :button_text, :url, presence: true
end
