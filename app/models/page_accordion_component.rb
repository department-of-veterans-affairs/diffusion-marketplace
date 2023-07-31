class PageAccordionComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true

  FORM_FIELDS = { # Fields and labels in .arb form
    title: 'Title',
    text: 'Text',
    has_border: 'Add border'
  }.freeze

end