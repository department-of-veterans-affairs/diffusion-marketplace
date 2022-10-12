class PageMapComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true

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
end