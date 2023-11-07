class PageParagraphComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true

  FORM_FIELDS = { # Fields and labels in .arb form
    text: 'Text'
  }.freeze
end
