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
    facility_data = VaFacility.cached_va_facilities.get_relevant_attributes
    practice_diffusion_histories = p.diffusion_histories.map { |dh|
      selected_facility = facility_data.select { |fd| fd.station_number === dh.va_facility.station_number }

      dh_status = dh.diffusion_history_statuses.first
      {
        facility_name: selected_facility[0].official_station_name,
        common_name: selected_facility[0].common_name,
        state: selected_facility[0].street_address_state,
        date: dh_status.status == 'In progress' || dh_status.status == 'Implementing' || dh_status.status == 'Planning' || dh_status.status == 'Unsuccessful' ? dh_status.start_time : dh_status.end_time,
        status: dh_status.status == 'Completed' || dh_status.status == 'Implemented' || dh_status.status == 'Complete' ? 'Successful' : dh_status.status,
        rurality: selected_facility[0].rurality,
        complexity: selected_facility[0].fy17_parent_station_complexity_level,
        station_number: selected_facility[0].station_number,
        visn: selected_facility[0].visn,
        practice_name: dh.practice.name
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
    @xlsx_entry_text_top = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :top, wrap_text: true}
    @xlsx_entry_text_bottom = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :bottom, wrap_text: true}
  end

  def get_search_term_counts_by_type(ahoy_event_name, search_terms_array)
    set_date_values
    events = Ahoy::Event.where(name: ahoy_event_name).where("properties->>'search_term' is not null").group("properties->>'search_term'").order('count_all desc').count
    events.each do |e|
      search_terms_array << {
        query: e[0],
        lifetime_count: e[1],
        current_month_count: Ahoy::Event.count_for_range(ahoy_event_name, @beginning_of_current_month, @end_of_current_month, e[0]),
        last_month_count: Ahoy::Event.count_for_range(ahoy_event_name, @beginning_of_last_month, @end_of_last_month, e[0]),
        two_months_ago_count: Ahoy::Event.count_for_range(ahoy_event_name, @beginning_of_two_months_ago, @end_of_two_months_ago, e[0]),
        three_months_ago_count: Ahoy::Event.count_for_range(ahoy_event_name, @beginning_of_three_months_ago, @end_of_three_months_ago, e[0])
      }
    end

    search_terms_array.sort_by {|k| k["current_month_count"]}.reverse!
    search_terms_array
  end

  def create_search_terms_table_by_type(panel_title, search_terms_array, table_id)
    set_date_values

    panel panel_title do
      columns do
        column do
          table_for search_terms_array, id: table_id do
            column('Term') {|st| st[:query]}
            column("#{@date_headers[:current]}") {|st| st[:current_month_count]}
            column("#{@date_headers[:one_month_ago]}") {|st| st[:last_month_count]}
            column("#{@date_headers[:two_month_ago]}") {|st| st[:two_months_ago_count]}
            column("#{@date_headers[:three_month_ago]}") {|st| st[:three_months_ago_count]}
            column("Lifetime") {|st| st[:lifetime_count]}
          end
        end
      end
    end

    script do
      total_current_month_searches = search_terms_array.sum {|st| st[:current_month_count] }
      total_last_month_searches = search_terms_array.sum {|st| st[:last_month_count]}
      total_two_months_ago_searches = search_terms_array.sum {|st| st[:two_months_ago_count]}
      total_three_months_ago_searches = search_terms_array.sum {|st| st[:three_months_ago_count]}
      total_lifetime_searches = search_terms_array.sum {|st| st[:lifetime_count]}
      raw "$(document).ready(function($) {
              $('##{table_id}').append('<tr><td><b>Totals</b></td><td><b>#{total_current_month_searches}</b></td><td><b>#{total_last_month_searches}</b></td><td><b>#{total_two_months_ago_searches}</b></td><td><b>#{total_three_months_ago_searches}</b></td><td><b>#{total_lifetime_searches}</b></td></tr>');
            });
          "
    end
  end

  def get_search_count_totals_by_date_range(search_totals_array)
    set_date_values
    search_term_not_null = "properties->>'search_term' is not null"

    total_search_events_count = Ahoy::Event.where(
      name: 'Practice search').where(search_term_not_null).or(
      Ahoy::Event.where(name: 'VISN practice search').where(search_term_not_null)).or(
      Ahoy::Event.where(name: 'Facility practice search').where(search_term_not_null)).count

    search_totals_array << {
      current_month_count: Ahoy::Event.total_search_term_counts_for_range(@beginning_of_current_month, @end_of_current_month),
      last_month_count: Ahoy::Event.total_search_term_counts_for_range(@beginning_of_last_month, @end_of_last_month),
      two_months_ago_count: Ahoy::Event.total_search_term_counts_for_range(@beginning_of_two_months_ago, @end_of_two_months_ago),
      three_months_ago_count: Ahoy::Event.total_search_term_counts_for_range(@beginning_of_three_months_ago, @end_of_three_months_ago),
      total: total_search_events_count
    }

    search_totals_array
  end

  def create_search_count_totals_table(search_totals_array)
    panel 'Total search counts' do
      columns do
        column do
          table_for search_totals_array, class: 'total-search-counts' do
            column("#{@date_headers[:current]}") {|ast| ast[:current_month_count]}
            column("#{@date_headers[:one_month_ago]}") {|ast| ast[:last_month_count]}
            column("#{@date_headers[:two_month_ago]}") {|ast| ast[:two_months_ago_count]}
            column("#{@date_headers[:three_month_ago]}") {|ast| ast[:three_months_ago_count]}
            column("Lifetime") {|ast| ast[:total]}
          end
        end
      end
    end
  end

  def add_adoption_columns(adoption_data, sheet, options = { :add_practice_name => false })
      sheet.add_row [
                     options[:add_practice_name] ? 'Practice' : nil,
                    'State',
                    'Location',
                    'VISN',
                    'Station Number',
                    'Adoption Date',
                    'Adoption Status',
                    'Rurality',
                    'Facility Complexity'
                  ].compact, style: @xlsx_sub_header_3

    adoption_data.each do |data_array|
      # adoption information
      if options[:add_practice_name]
        data_array.each do |hash|
          sheet.add_row [
                          hash[:practice_name],
                          hash[:state],
                          adoption_facility_name(hash),
                          hash[:visn].number,
                          hash[:station_number],
                          adoption_date(hash),
                          adoption_status(hash),
                          adoption_rurality(hash),
                          hash[:complexity]
                        ], style: @xlsx_entry_text_bottom

        end
      else
        sheet.add_row [
                        data_array[:state],
                        adoption_facility_name(data_array),
                        data_array[:visn].number,
                        data_array[:station_number],
                        adoption_date(data_array),
                        adoption_status(data_array),
                        adoption_rurality(data_array),
                        data_array[:complexity]
                      ], style: @xlsx_entry_text_bottom
      end
    end
  end
end