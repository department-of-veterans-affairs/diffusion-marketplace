class Page < ApplicationRecord
  has_paper_trail
  belongs_to :page_group
  has_many :page_components, -> { order(position: :asc) }, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :page_components, allow_destroy: true
  validates :slug, presence: true, length: {maximum: 255}
  validates :title, presence: true
  # prevent DB creation of a page that has a description over 140 characters long
  validates :description, presence: true, length: { maximum: 140 }
  SLUG_FORMAT = /^[a-zA-Z0-9_-]*$*/
  validates_uniqueness_of :slug,
                          scope: :page_group_id,
                          case_sensitive: false

  validates :slug, format: { with: Regexp.new('\A' + SLUG_FORMAT.source + '\z'), message: "invalid characters in URL" }
  before_validation :downcase_fields

  enum template_type: {default: 0, narrow: 1}

  private

  def self.get_adopting_facilities(map_component)
    va_facilities_list = []
    map_component.practices.each do |pr|
      diffusion_histories = DiffusionHistory.where(practice_id: pr)
      diffusion_histories.each do |dh|
        dhs = DiffusionHistoryStatus.where(diffusion_history_id: dh[:id]).first.status
        unless dh.va_facility_id.nil?
          if (dhs == 'Completed' || dhs == 'Implemented' || dhs == 'Complete') && map_component.display_successful_adoptions
            va_facilities_list.push dh.va_facility_id
          elsif (dhs == 'In progress' || dhs == 'Planning' || dhs == 'Implementing') && map_component.display_in_progress_adoptions
            va_facilities_list.push dh.va_facility_id
          elsif dhs == "Unsuccessful" && map_component.display_unsuccessful_adoptions
            va_facilities_list.push dh.va_facility_id
          end
        end
      end
    end
    va_facilities_list
  end

  def downcase_fields
    self.slug = self.slug&.downcase
  end
end
