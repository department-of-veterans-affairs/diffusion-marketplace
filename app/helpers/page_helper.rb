module PageHelper
  def practices_to_display_in_info_window(facility_id, practice_list, names, taglines, short_names, slugs)
    dh = DiffusionHistory.where(va_facility_id: facility_id)
    dh.each do |dh|
      if practice_list.practices.include?(dh.practice_id.to_s)
        names.push dh.practice.name
        short_names.push dh.practice.short_name
        taglines.push dh.practice.tagline
        slugs.push dh.practice.slug
      end
    end
  end
end
