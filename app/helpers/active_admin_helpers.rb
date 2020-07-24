module ActiveAdminHelpers
  def adoption_facility_name(v)
    v[:facility_name].downcase.include?(v[:common_name].downcase) ? v[:facility_name] : "#{v[:facility_name]} (#{v[:common_name]})"
  end

  def adoption_date(v)
    v[:date] == nil ? 'N/A' : v[:date].strftime('%B %Y')
  end

  def adoption_rurality(v)
    v[:rurality] === 'U' ? 'Urban' : 'Rural'
  end

  def get_adoption_values(p, complete_map)
    facility_data = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
    practice_diffusion_histories = p.diffusion_histories.map { |dh|
      selected_facility = facility_data.select { |fd| fd["StationNumber"] === dh.facility_id }

      dh_status = dh.diffusion_history_statuses.first
      {
        facility_name: selected_facility[0]["OfficialStationName"],
        common_name: selected_facility[0]["CommonName"],
        state: selected_facility[0]["MailingAddressState"],
        date: dh_status.status == 'In progress' || dh_status.status == 'Implementing' || dh_status.status == 'Planning' || dh_status.status == 'Unsuccessful' ? dh_status.start_time : dh_status.end_time,
        status: dh_status.status,
        rurality: selected_facility[0]["Rurality"],
        complexity: selected_facility[0]["FY17ParentStationComplexityLevel"],
        station_number: selected_facility[0]["StationNumber"],
        visn: selected_facility[0]["VISN"]
      }
    }
    sorted_diffusion_histories = practice_diffusion_histories.sort_by { |pdh| [pdh[:state], pdh[:facility_name]] }
    complete_map[p.name] = sorted_diffusion_histories
  end

  def adoption_xlsx_styles(p)
    s = p.workbook.styles
    @xlsx_main_header = s.add_style sz: 18, alignment: { horizontal: :center }, bg_color: '005EA2', fg_color: 'FFFFFF'
    @xlsx_sub_header_2 = s.add_style sz: 16, alignment: { horizontal: :left }, bg_color: '585858', fg_color: 'FFFFFF'
    @xlsx_sub_header_3 = s.add_style sz: 14, alignment: { horizontal: :center }, bg_color: 'F3F3F3', fg_color: '000000', b: true, border: {style: :thin, color: '000000', edges: [:top, :bottom, :left, :right]}
    @xlsx_entry = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center, wrap_text: true}
    @xlsx_divider = s.add_style sz: 12
    @xlsx_legend_no_bottom_border = s.add_style b: true, u: true, border: {style: :thin, color: 'FFFFFF', edges: [:bottom]}
    @xlsx_legend_no_top_border = s.add_style b: true, border: {style: :thin, color: 'FFFFFF', edges: [:top]}
    @xlsx_legend_no_y_border = s.add_style b: true, border: {style: :thin, color: 'FFFFFF', edges: [:bottom, :top]}
  end
end