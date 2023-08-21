class PageTripleParagraphComponent < ApplicationRecord
      has_one :page_component, as: :component, autosave: true
  validates :title1, :title2, :title3, presence: true
  validates :text1, :text2, :text3, presence: true

  FORM_FIELDS = { # Fields and labels in .arb form
    has_background_color?: 'Add Background Color',
    title1:'Title 1',
    text1:'Body 1',
    title2:'Title 2',
    text2:'Body 2',
    title3:'Title 3',
    text3:'Body 3'
  }.freeze
end