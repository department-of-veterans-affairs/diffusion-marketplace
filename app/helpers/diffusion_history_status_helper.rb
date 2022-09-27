module DiffusionHistoryStatusHelper

  def get_adopting_facilities_for_these_practices(practices_list, successful_adoptions, in_progress_adoptions, unsuccessful_adoptions)
    debugger
    va_facilities_list = []
    practices_list.practices.each do |pr|
      diffusion_histories = DiffusionHistory.where(practice_id: pr)
      diffusion_histories.each do |dh|
        dhs = DiffusionHistoryStatus.where(diffusion_history_id: dh[:id]).first.status
        unless dh.va_facility_id.nil?
          if (dhs == 'Completed' || dhs == 'Implemented' || dhs == 'Complete') && successful_adoptions
            va_facilities_list.push dh.va_facility_id
          elsif (dhs == 'In progress' || dhs == 'Planning' || dhs == 'Implementing') && in_progress_adoptions
            va_facilities_list.push dh.va_facility_id
          elsif dhs == "Unsuccessful" && unsuccessful_adoptions
            va_facilities_list.push dh.va_facility_id
          end
        end
      end
    end
    va_facilities_list
  end

end