include ActiveAdminHelpers

ActiveAdmin.register_page "Adoptions" do
  controller do
    helper_method :adoption_facility_name
    helper_method :adoption_date
    helper_method :adoption_rurality
    helper_method :adoption_xlsx_styles
    helper_method :get_adoption_values
    before_action :set_adoption_values

    def set_adoption_values
      @practices = Practice.order(Arel.sql("lower(name) ASC"))
      @complete_map = {}
      @practices.each do |p|
        get_adoption_values(p, @complete_map)
      end
    end
  end

  page_action :export_all_adoptions, method: :get do
      metrics_xlsx_file = Axlsx::Package.new do |p|
        # styling
        adoption_xlsx_styles(p)

        # building out xlsx file
        p.workbook.add_worksheet(:name => "Practice Adoptions - #{Date.today}") do |sheet|
          sheet.add_row ["Adoptions by Practice - #{Date.today}"], style: @xlsx_main_header
          sheet.add_row [''], style: @xlsx_divider
          sheet.add_row ['Note: Adoption date is based on the adoption status.'], style: @xlsx_legend_no_bottom_border
          sheet.add_row ['Completed/Unsuccessful: End Date'], style: @xlsx_legend_no_y_border
          sheet.add_row ['In Progress: Start Date'], style: @xlsx_legend_no_top_border
          sheet.merge_cells 'A1:C1'
          sheet.add_row [''], style: @xlsx_divider

          @complete_map.each do |key, value|
            if value.present?
              sheet.add_row [key], style: @xlsx_sub_header_2
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
                                  v[:status],
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
    if DiffusionHistory.any?
      h1 'Adoptions by practice'
      div(class: 'form-and-legend-container') do
        # export .xlsx button
        form action: admin_adoptions_export_all_adoptions_path, method: :get, style: 'text-align: left' do |f|
          f.input :submit, type: :submit, value: 'Download All', style: 'margin-bottom: 1rem'
        end
        div(class: 'adoptions-legend') do
          h4 do
            span 'Note: '
            span 'Adoption date is based on the adoption status.'
          end
          ul do
            li do
              span 'Completed/Unsuccessful: '
              span 'End Date'
            end
            li do
              span 'In Progress: '
              span 'Start Date'
            end
          end
        end
      end

      columns do
        complete_map.each do |name, value|
          if value.present?
            panel "#{name}" do
              table_for value do
                column('State') { |v| v[:state] }
                column('Location') { |v| adoption_facility_name(v) }
                column('VISN') { |v| v[:visn] }
                column('Station Number') { |v| v[:station_number] }
                column('Date') { |v| adoption_date(v) }
                column('Status') { |v| v[:status] }
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