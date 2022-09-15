class PageCompoundBodyComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true

  validates :text_alignment, allow_blank: true, inclusion: {
    in: %w[Left Right],
    message: "%{value} is not a valid text alignment"
  }
  validates :margin_bottom, :margin_top, allow_blank: true, inclusion: {
    in: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    message: "%{value} is not a valid %{attribute} size"
  }
  validates_with InternalUrlValidator, on: [:create, :update], if: Proc.new { |component| component.url.present? && component.url.chars.first === '/' }
  validates_with ExternalUrlValidator, on: [:create, :update], if: Proc.new { |component| component.url.present? && component.url.chars.first != '/' }
end