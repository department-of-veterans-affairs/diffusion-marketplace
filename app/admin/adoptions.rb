include ActiveAdminHelpers

ActiveAdmin.register_page "Adoptions" do
  controller do
    helper_method :adoption_facility_name
    helper_method :adoption_date
    helper_method :adoption_rurality
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
        s = p.workbook.styles
        xlsx_main_header = s.add_style sz: 18, alignment: { horizontal: :center }, bg_color: '005EA2', fg_color: 'FFFFFF'
        xlsx_sub_header_2 = s.add_style sz: 16, alignment: { horizontal: :left }, bg_color: '585858', fg_color: 'FFFFFF'
        xlsx_sub_header_3 = s.add_style sz: 14, alignment: { horizontal: :center }, bg_color: 'F3F3F3', fg_color: '000000', b: true, border: {style: :thin, color: '000000', edges: [:top, :bottom, :left, :right]}
        xlsx_entry = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center, wrap_text: true}
        xlsx_divider = s.add_style sz: 12
        # building out xlsx file
        p.workbook.add_worksheet(:name => "Practice Adoptions - #{Date.today}") do |sheet|
          sheet.add_row ["Adoptions by Practice - #{Date.today}"], style: xlsx_main_header
          @complete_map.each do |key, value|
            sheet.add_row [key], style: xlsx_sub_header_2
            if value.present?
              sheet.add_row [
                                'State',
                                'Location',
                                'VISN',
                                'Station Number',
                                'Date',
                                'Status',
                                'Rurality',
                                'Facility Complexity'
                            ], style: xlsx_sub_header_3

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
                              ], style: xlsx_entry
              end
            else
              sheet.add_row ['No adoptions recorded for this practice.']
            end
            sheet.add_row [''], style: xlsx_divider
          end
        end
      end
      # generating downloadable .xlsx file
      send_data metrics_xlsx_file.to_stream.read, :filename => "dm_adoptions_#{Date.today}.xlsx", :type => "application/xlsx"
  end

  content do
    h1 'Adoptions by practice'
    div(class: 'form-and-legend-container') do
      # export .xlsx button
      form action: admin_adoptions_export_all_adoptions_path, method: :get, style: 'text-align: left' do |f|
        f.input :submit, type: :submit, value: 'Download all', style: 'margin-bottom: 1rem'
      end
      div(class: 'adoptions-legend') do
        h4 do
          span 'Note: '
          span 'Date is based on the adoption status.'
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
        panel "#{name}" do
          if value.present?
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
          else
            para 'No adoptions recorded for this practice'
          end
        end
      end
    end
  end
end