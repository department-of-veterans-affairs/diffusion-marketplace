module PageHelper
  def get_practices_by_diffusion_histories(facility_id, map_component, names, taglines, short_names, slugs)
    dh = DiffusionHistory.where(va_facility_id: facility_id)
    dh.each do |dh|
      if map_component.practices.include?(dh.practice_id.to_s)
        names.push dh.practice.name
        short_names.push dh.practice.short_name
        taglines.push dh.practice.tagline
        slugs.push dh.practice.slug
      end
    end
  end
end
