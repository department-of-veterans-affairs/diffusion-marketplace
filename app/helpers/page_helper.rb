module PageHelper
  def practices_to_display_in_info_window(facility_id, practice_list, names, taglines, short_names)
    dh = DiffusionHistory.where(va_facility_id: facility_id)
    dh.each do |dh|
      if practice_list.practices.include?(dh.practice_id.to_s)
        names.push Practice.find_by_id(dh.practice_id).name
        short_names.push Practice.find_by_id(dh.practice_id).short_name
        taglines.push Practice.find_by_id(dh.practice_id).tagline
      end
    end
  end
end
