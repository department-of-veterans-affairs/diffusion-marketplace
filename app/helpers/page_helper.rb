module PageHelper
  def practices_to_display_in_info_window(facility_id, practice_list)
    practices_for_facility = ""
    dh = DiffusionHistory.where(va_facility_id: facility_id)
    dh.each do |dh|
      if practice_list[0][0][:practices].include?(dh.practice_id.to_s)
        practices_for_facility += Practice.find_by_id(dh.practice_id).name + ","
      end
    end
    practices_for_facility.chop
  end
end
