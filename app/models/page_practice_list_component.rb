class PagePracticeListComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true

  FORM_FIELDS = { # Fields and labels in .arb form
    practices: 'Innovations'
  }.freeze
end
