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

  def adoption_status(v)
    v[:status] == 'Completed' || v[:status] == 'Implemented' || v[:status] == 'Complete' ? 'Successful' : v[:status]
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
        status: dh_status.status == 'Completed' || dh_status.status == 'Implemented' || dh_status.status == 'Complete' ? 'Successful' : dh_status.status,
        rurality: selected_facility[0]["Rurality"],
        complexity: selected_facility[0]["FY17ParentStationComplexityLevel"],
        station_number: selected_facility[0]["StationNumber"],
        visn: selected_facility[0]["VISN"]
      }
    }
    sorted_diffusion_histories = practice_diffusion_histories.sort_by { |pdh| [pdh[:state], pdh[:facility_name]] }
    complete_map[p.name] = sorted_diffusion_histories
  end

  def set_date_values
    @beginning_of_current_month = Date.today.at_beginning_of_month.beginning_of_day
    @end_of_current_month = Date.today.at_end_of_month.end_of_day
    @beginning_of_last_month = (Date.today - 1.months).at_beginning_of_month.beginning_of_day
    @end_of_last_month = (Date.today - 1.months).at_end_of_month.end_of_day
    @beginning_of_two_months_ago = (Date.today - 2.months).at_beginning_of_month.beginning_of_day
    @end_of_two_months_ago = (Date.today - 2.months).at_end_of_month.end_of_day
    @beginning_of_three_months_ago = (Date.today - 3.months).at_beginning_of_month.beginning_of_day
    @end_of_three_months_ago = (Date.today - 3.months).at_end_of_month.end_of_day

    @date_headers = {
        total: 'Current Total',
        current: "#{@beginning_of_current_month.strftime('%B %Y')} - current month",
        one_month_ago: "#{@beginning_of_last_month.strftime('%B %Y')} - last month",
        two_month_ago: "#{@beginning_of_two_months_ago.strftime('%B %Y')} - 2 months ago",
        three_month_ago: "#{@beginning_of_three_months_ago.strftime('%B %Y')} - 3 months ago"
    }
  end

  def all_adoption_counts
    set_date_values
    {
      adoptions_this_month: DiffusionHistory.where(created_at: @beginning_of_current_month..@end_of_current_month).count,
      adoptions_one_month_ago: DiffusionHistory.where(created_at: @beginning_of_last_month..@end_of_last_month).count,
      adoptions_two_months_ago: DiffusionHistory.where(created_at: @beginning_of_two_months_ago..@end_of_two_months_ago).count,
      total_adoptions: DiffusionHistory.count
    }
  end

  def adoption_counts_by_practice(p)
    set_date_values
    {
        adopted_this_month: p.diffusion_histories.where(created_at: @beginning_of_current_month..@end_of_current_month).count,
        adopted_one_month_ago: p.diffusion_histories.where(created_at: @beginning_of_last_month..@end_of_last_month).count,
        adopted_two_months_ago: p.diffusion_histories.where(created_at: @beginning_of_two_months_ago..@end_of_two_months_ago).count,
        total_adopted: p.diffusion_histories.count
    }
  end

  def adoption_xlsx_styles(p)
    s = p.workbook.styles
    @xlsx_main_header = s.add_style sz: 18, alignment: { horizontal: :center }, bg_color: '005EA2', fg_color: 'FFFFFF'
    @xlsx_sub_header = s.add_style sz: 16, alignment: { horizontal: :center }, bg_color: 'FFFFFF', fg_color: '005EA2', b: true, border: {style: :thin, color: '000000', edges: [:top, :bottom, :left, :right]}
    @xlsx_sub_header_2 = s.add_style sz: 16, alignment: { horizontal: :left }, bg_color: '585858', fg_color: 'FFFFFF'
    @xlsx_sub_header_3 = s.add_style sz: 14, alignment: { horizontal: :center }, bg_color: 'F3F3F3', fg_color: '000000', b: true, border: {style: :thin, color: '000000', edges: [:top, :bottom, :left, :right]}
    @xlsx_entry = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center, wrap_text: true}
    @xlsx_divider = s.add_style sz: 12
    @xlsx_legend_no_bottom_border = s.add_style b: true, u: true, border: {style: :thin, color: 'FFFFFF', edges: [:bottom]}
    @xlsx_legend_no_top_border = s.add_style b: true, border: {style: :thin, color: 'FFFFFF', edges: [:top]}
    @xlsx_legend_no_y_border = s.add_style b: true, border: {style: :thin, color: 'FFFFFF', edges: [:bottom, :top]}
  end
end