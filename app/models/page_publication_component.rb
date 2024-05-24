class PagePublicationComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
  has_attached_file :attachment, :default_url => ""
  do_not_validate_attachment_file_type :attachment
  validates :title, presence: true
  validates :published_on_day, numericality: { only_integer: true, less_than_or_equal_to: 31 }, allow_nil: true
  validates :published_on_month, numericality: { only_integer: true, less_than_or_equal_to: 12 }, allow_nil: true
  validates :published_on_year, length: { is: 4 }, numericality: { only_integer: true }, allow_nil: true

  validates_with InternalUrlValidator,
                 on: [:create, :update],
                 if: Proc.new { |component| component.url.present? && component.url.chars.first === '/' }
  validates_with ExternalUrlValidator,
                 on: [:create, :update],
                 if: Proc.new { |component| component.url.present? && component.url.chars.first != '/' }

  FORM_FIELDS = { # Fields and labels in .arb form
    published_in: 'Published in',
    published_on_month: 'Month',
    published_on_day: 'Day',
    published_on_year: 'Year',
    authors: 'Authors'
  }.freeze

  def attachment_s3_presigned_url(style = nil)
    object_presigned_url(attachment, style)
  end

  def publication_date
    if self.published_on_month? && self.published_on_day? && self.published_on_year? # on Month Day, Year
      return "on #{Date::MONTHNAMES[self.published_on_month]} #{self.published_on_day}, #{self.published_on_year}"
    elsif self.published_on_month? && self.published_on_year?  # in Month Year
      return "in #{Date::MONTHNAMES[self.published_on_month]} #{self.published_on_year}"
    elsif self.published_on_year # in Year
      return "in #{self.published_on_year}"
    else # do not render incomplete date field combos (e.g. Month only, Date only)
      return nil
    end
  end
end
