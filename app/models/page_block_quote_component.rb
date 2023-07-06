class PageBlockQuoteComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
  validates :text, :citation, presence: true

  before_save :strip_p_tags_from_text

  private

  def strip_p_tags_from_text
    # Replace the <p> tags with an empty string
    self.text = text.gsub(/<\/?p>/, '')
    self.citation = citation.gsub(/<\/?p>/, '')
  end
end