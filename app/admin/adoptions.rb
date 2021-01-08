include ActiveAdminHelpers

ActiveAdmin.register_page "Adoptions" do
  controller do
    helper_method :adoption_facility_name
    helper_method :adoption_date
    helper_method :adoption_rurality
    helper_method :adoption_status
    helper_method :adoption_xlsx_styles
    helper_method :get_adoption_values
    helper_method :adoption_counts_by_practice
    helper_method :all_adoption_counts
    before_action :set_adoption_values

    def set_adoption_values
      @practices = Practice.order(Arel.sql("lower(name) ASC"))
      @complete_map = {}
      @practice_adoption_counts = {}
      @practice_ids = {}
      @practices.each do |p|
        get_adoption_values(p, @complete_map)
        @practice_adoption_counts[p.name] = adoption_counts_by_practice(p)
        @practice_ids.merge!({p.name => p.id})
      end
      @all_adoption_counts = all_adoption_counts
    end
  end

  page_action :export_all_adoptions, method: :get do
      metrics_xlsx_file = Axlsx::Package.new do |p|
        # styling
        adoption_xlsx_styles(p)

        # building out xlsx file
        p.workbook.add_worksheet(:name => "Practice Adoptions - #{Date.today}") do |sheet|
          sheet.add_row ['Practice Adoptions'], style: @xlsx_main_header
          sheet.add_row [''], style: @xlsx_divider
          sheet.add_row ['Please Note'], style: @xlsx_legend_no_bottom_border
          sheet.add_row ['Adoption date is based on the adoption status.'], style: @xlsx_legend_no_y_border
          sheet.add_row [''], style: @xlsx_divider
          sheet.add_row ['Successful/Unsuccessful: End Date'], style: @xlsx_legend_no_y_border
          sheet.add_row ['In Progress: Start Date'], style: @xlsx_legend_no_top_border
          sheet.merge_cells 'A1:C1'
          sheet.add_row [''], style: @xlsx_divider

          sheet.add_row ['All adoptions'], style: @xlsx_sub_header_2
          sheet.add_row ["#{@date_headers[:current]}", @all_adoption_counts[:adoptions_this_month]], style: @xlsx_entry
          sheet.add_row ["#{@date_headers[:one_month_ago]}", @all_adoption_counts[:adoptions_one_month_ago]], style: @xlsx_entry
          sheet.add_row ["#{@date_headers[:two_month_ago]}", @all_adoption_counts[:adoptions_two_months_ago]], style: @xlsx_entry
          sheet.add_row ["#{@date_headers[:total]}", @all_adoption_counts[:total_adoptions]], style: @xlsx_entry

          sheet.add_row [''], style: @xlsx_divider

          @complete_map.each do |name, value|
            if value.present?
              practice_id = @practice_ids[name]
              sheet.add_row [name], style: @xlsx_sub_header_2
              sheet.add_row ["Practice Id", practice_id], style: @xlsx_entry
              # adoption counts
              sheet.add_row ['Adoption Counts'], style: @xlsx_sub_header
              @practice_adoption_counts.each do |key, counts|
                if key == name
                  sheet.add_row ["#{@date_headers[:current]}", counts[:adopted_this_month]], style: @xlsx_entry
                  sheet.add_row ["#{@date_headers[:one_month_ago]}", counts[:adopted_one_month_ago]], style: @xlsx_entry
                  sheet.add_row ["#{@date_headers[:two_month_ago]}", counts[:adopted_two_months_ago]], style: @xlsx_entry
                  sheet.add_row ["#{@date_headers[:total]}", counts[:total_adopted]], style: @xlsx_entry
                end
              end

              sheet.add_row [''], style: @xlsx_divider

              # adoption information
              sheet.add_row ['Adoption Information'], style: @xlsx_sub_header
              sheet.add_row [
                  'State',
                  'Location',
                  'VISN',
                  'Station Number',
                  'Adoption Date',
                  'Adoption Status',
                  'Rurality',
                  'Facility Complexity'
              ], style: @xlsx_sub_header_3

              value.each do |v|
                sheet.add_row [
                    v[:state],
                    adoption_facility_name(v),
                    v[:visn],
                    v[:station_number],
                    adoption_date(v),
                    adoption_status(v),
                    adoption_rurality(v),
                    v[:complexity]
                ], style: @xlsx_entry
              end
              sheet.add_row [''], style: @xlsx_divider
            end
          end
        end
        p.use_shared_strings = true
      end
      # generating downloadable .xlsx file
      send_data metrics_xlsx_file.to_stream.read, :filename => "dm_adoptions_#{Date.today}.xlsx", :type => "application/xlsx"
  end

  content do
    div(class: 'form-and-legend-container') do
      # export .xlsx button
      form action: admin_adoptions_export_all_adoptions_path, method: :get, style: 'text-align: left' do |f|
        f.input :submit, type: :submit, value: 'Download All', style: 'margin-bottom: 1rem'
      end

      div(class: 'adoptions-legend') do
        h3 do
          'Please Note'
        end
        h4 do
          span 'Adoption date is based on the adoption status.'
        end
        ul do
          li do
            span 'Successful/Unsuccessful: '
            span 'End Date'
          end
          li do
            span 'In Progress: '
            span 'Start Date'
          end
        end
      end
    end

    if DiffusionHistory.any?
      panel 'All adoptions' do
        columns class: 'all-adoptions-columns' do
          table_for all_adoption_counts do
            column("#{date_headers[:current]}", class: "all-adoptions-current-month") {|ac| ac[:adoptions_this_month]}
            column("#{date_headers[:one_month_ago]}", class: "all-adoptions-last-month") {|ac| ac[:adoptions_one_month_ago]}
            column("#{date_headers[:two_month_ago]}", class: "all-adoptions-two-months-ago") {|ac| ac[:adoptions_two_months_ago]}
            column("#{date_headers[:total]}", class: "all-adoptions-total") {|ac| ac[:total_adoptions]}
          end
        end
      end

      columns do
        complete_map.each do |name, value|
          if value.present?
            panel "#{name}" do

              h3 do
                "Adoption Counts"
              end
              practice_adoption_counts.each do |key, counts|
                if key == name
                  table_for counts do
                    column("#{date_headers[:current]}") {|c| c[:adopted_this_month]}
                    column("#{date_headers[:one_month_ago]}") {|c| c[:adopted_one_month_ago]}
                    column("#{date_headers[:two_month_ago]}") {|c| c[:adopted_two_months_ago]}
                    column("#{date_headers[:total]}") {|c| c[:total_adopted]}
                  end
                end
              end

              h3 do
                "Adoption Information"
              end
              table_for value do
                column('State') { |v| v[:state] }
                column('Location') { |v| adoption_facility_name(v) }
                column('VISN') { |v| v[:visn] }
                column('Station Number') { |v| v[:station_number] }
                column('Date') { |v| adoption_date(v) }
                column('Status') { |v| adoption_status(v) }
                column('Rurality') { |v| adoption_rurality(v) }
                column('Facility Complexity') { |v| v[:complexity]  }
              end
            end
          end
        end
      end
    else
      div(class: 'no-adoptions-div') do
        h1 'No adoptions have been recorded'
      end
    end
  end
end