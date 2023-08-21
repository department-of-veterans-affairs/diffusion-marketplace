class PageSimpleButtonComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
  validates :button_text, :url, presence: true

  validates_with InternalUrlValidator,
                 on: [:create, :update],
                 if: Proc.new { |component| component.url.present? && component.url.chars.first === '/' }
  validates_with ExternalUrlValidator,
                 on: [:create, :update],
                 if: Proc.new { |component| component.url.present? && component.url.chars.first != '/' }

    FORM_FIELDS = { # Fields and labels in .arb form
      button_text: 'Button Text',
      url: 'Button URL'
    }.freeze
end
