class PageMapComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true

  FORM_FIELDS = { # Fields and labels in .arb form
    title: 'Title',
    map_info_window_text: 'Map Info Window Text',
    description_text_alignment: 'Text alignment',
    description: 'Description',
    practices: 'Innovation List',
    display_successful_adoptions?: 'Successful',
    display_in_progress_adoptions?: 'In Progress',
    display_unsuccessful_adoptions?: 'Unsuccessful'
  }.freeze

  CACHE_IMPACTING_FIELDS = [
    :practices,
    :display_successful_adoptions,
    :display_in_progress_adoptions,
    :display_unsuccessful_adoptions
  ].freeze

  after_commit :reset_cached_map_data, if: :cache_impacting_fields_changed?

  def get_practice_data_by_diffusion_histories(facility_id)
    adoptions = DiffusionHistory.where(va_facility_id: facility_id)
    info_window_practice_data = []
    adoptions.each do |adoption|
    adoption_practice = DiffusionHistory.get_with_practice(adoption.practice).first.practice
      if practices.include?(adoption_practice.id.to_s)
        info_window_practice_data << adoption_practice.slice(:name, :short_name, :tagline, :slug)
      end
    end
    info_window_practice_data
  end

  def get_adopting_facility_ids
    va_facility_ids = []
    practices.each do |pr|
      diffusion_histories = DiffusionHistory.where(practice_id: pr)
      diffusion_histories.each do |dh|
        dhs = DiffusionHistoryStatus.where(diffusion_history_id: dh[:id]).first.status
        unless dh.va_facility_id.nil?
          if (dhs == 'Completed' || dhs == 'Implemented' || dhs == 'Complete') && display_successful_adoptions
            va_facility_ids.push dh.va_facility_id
          elsif (dhs == 'In progress' || dhs == 'Planning' || dhs == 'Implementing') && display_in_progress_adoptions
            va_facility_ids.push dh.va_facility_id
          elsif dhs == "Unsuccessful" && display_unsuccessful_adoptions
            va_facility_ids.push dh.va_facility_id
          end
        end
      end
    end
    va_facility_ids
  end

  def reset_cached_map_data
    Rails.cache.delete("page_map_component_markers_#{page_component&.page&.id}")
  end

  def cache_impacting_fields_changed?
    CACHE_IMPACTING_FIELDS.any? { |field| saved_change_to_attribute?(field) }
  end
end
