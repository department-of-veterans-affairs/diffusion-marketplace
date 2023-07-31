class PageEventComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true

  FORM_FIELDS = { # Fields and labels in .arb form
    title: 'Title',
    url: 'URL',
    presented_by: 'Presented by',
    start_date: 'Start date',
    end_date: 'End date',
    location: 'Location',
    text: 'Description'
  }.freeze

  validates :start_date, presence: { message: 'Must provide a start date' } if :end_date?

  validates_with InternalUrlValidator,
                 on: [:create, :update],
                 if: Proc.new { |component| component.url.present? && component.url.chars.first === '/' }
  validates_with ExternalUrlValidator,
                 on: [:create, :update],
                 if: Proc.new { |component| component.url.present? && component.url.chars.first != '/' }

  def rendered_date
    return if self.start_date.blank?

    if self.end_date.present? && (self.start_date.year != self.end_date.year)
      return self.start_date.strftime("%B %e, %Y") + " - " + self.end_date.strftime("%B%e, %Y")
    elsif self.end_date.present? && (self.start_date.month != self.end_date.month)
      return self.start_date.strftime("%B %e") + " - " + self.end_date.strftime("%B%e, %Y")
    elsif self.end_date.present? && (self.start_date.month == self.end_date.month)
      return self.start_date.strftime("%B %e") + " - " + self.end_date.strftime("%e, %Y")
    else
      return self.start_date.strftime("%B %e, %Y")
    end
  end
end
