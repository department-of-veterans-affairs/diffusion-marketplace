class PageCtaComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
  validates :cta_text, :button_text, :url, presence: true

  FORM_FIELDS = { # Fields and labels in .arb for
    cta_text: 'CTA Text',
    button_text: 'Button Text',
    url: 'Action Link',
    has_background_color?: 'Add Background Color'
  }.freeze
end
