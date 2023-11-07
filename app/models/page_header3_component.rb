class PageHeader3Component < ApplicationRecord
  has_one :page_component, as: :component, autosave: true

  FORM_FIELDS = {
    title: 'Title',
    description: 'Description',
    alignment: 'Alignment',
    url: 'URL'
  }.freeze

  validates_with InternalUrlValidator, on: [:create, :update], if: Proc.new { |page_component| page_component.url.present? && page_component.url.chars.first === '/' }
  validates_with ExternalUrlValidator, on: [:create, :update], if: Proc.new { |page_component| page_component.url.present? && page_component.url.chars.first != '/' }
end
