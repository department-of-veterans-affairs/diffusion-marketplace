class PageTripleParagraphComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
  validates :title1, :title2, :title3, presence: true
  validates :text1, :text2, :text3, presence: true
end