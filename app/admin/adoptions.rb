ActiveAdmin.register_page "Adoptions" do
  content do
    para "Hello World"
  end

  controller do
    before_action :hello_world
    def hello_world
      @practices = Practice.all
      @adoptions = DiffusionHistory.all
      @facility_data = JSON.parse(File.read("#{Rails.root}/lib/assets/vamc.json"))
      puts @facility_data
    end
  end

  content do
    h1 'Adoptions by practice'

    # columns do
    #   column do
    #     panel "Practice Views Leaderboard" do
    #       table_for practices_views.each, id: 'practice-views-table' do
    #         column(:name) {|practice| link_to(practice.name, admin_practice_path(practice))}
    #         column("#{date_headers[:current]}") {|practice| practice.current_month_views}
    #         column("#{date_headers[:one_month_ago]}") {|practice| practice.last_month_views}
    #         column("#{date_headers[:two_month_ago]}") {|practice| practice.two_months_ago_views}
    #         column("#{date_headers[:three_month_ago]}") {|practice| practice.three_months_ago_views}
    #         column("Total lifetime views") {|practice| practice.views}
    #       end

    columns do
      practices.order(name: :asc).each do |p|
        panel "#{p.name}" do
          if p.diffusion_histories.exists?
            practice_diffusion_histories =
                p.diffusion_histories.map {|dh|
                  selected_facility = facility_data.select {|fd| fd["StationNumber"] === dh.facility_id }
                  # puts "facility", selected_facility
                  #this is what is getting returned
                  dh_status = dh.diffusion_history_statuses.first
                  {
                      facility_name: selected_facility[0]["OfficialStationName"],
                      date: dh_status.status == 'In progress' ? dh_status.start_time : dh_status.end_time,
                      status: dh_status.status,
                      rurality: selected_facility[0]["Rurality"],
                      complexity: selected_facility[0]["FY17ParentStationComplexityLevel"]
                  }
                }
            puts "pdh", practice_diffusion_histories
            table_for practice_diffusion_histories.each do
              column('Adoption Location') { |pdh| pdh[:facility_name] }
              column('Adoption Date') { |pdh| pdh[:date] }
              column('Adoption Status') { |pdh| pdh[:status] }
              column('Rurality') { |pdh| pdh[:rurality] }
              column('Facility Complexity') { |pdh| pdh[:complexity] }
            end
          else
            para 'No adoptions recorded for this practice'
          end
        end
      end
    end
  end
end