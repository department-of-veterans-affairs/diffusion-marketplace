ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc {I18n.t("active_admin.dashboard")}


  controller do
    helper_method :set_date_values
    helper_method :adoption_xlsx_styles
    before_action :set_dashboard_values

    def site_visits(start_time, end_time)
      Ahoy::Event.where(name: 'Site visit').where("properties->>'ip_address' is not null").where(time: start_time..end_time).group("properties->>'ip_address'").count
    end

    def set_dashboard_values
      set_date_values
      @enabled_published_practices = Practice.where(enabled: true, published: true)

      site_visit_stats = site_visits(@beginning_of_last_month, @end_of_last_month)
      @practices = @enabled_published_practices.order(name: :asc)
      @practices_views = @enabled_published_practices.sort_by(&:current_month_views).reverse!

      @practices_headers = ['Practice Name', "#{@date_headers[:current]}", "Last Month", "#{@date_headers[:total]}"]

      @general_traffic_stats = {
          unique_visitors: site_visit_stats.keys.length,
          number_of_site_visits: site_visit_stats.sum {|_k, v| v},
          total_accounts: User.all.count
      }

      @practices_added_stats = {
          added_this_month: @enabled_published_practices.where(created_at: @beginning_of_current_month..@end_of_current_month).count,
          added_one_month_ago: @enabled_published_practices.where(created_at: @beginning_of_last_month..@end_of_last_month).count,
          total_practices_created: @enabled_published_practices.count
      }

      @practices_favorited_stats = {
          favorited_this_month: UserPractice.where(time_favorited: @beginning_of_current_month..@end_of_current_month).count,
          favorited_one_month_ago: UserPractice.where(time_favorited: @beginning_of_last_month..@end_of_last_month).count,
          total_favorited: UserPractice.where(favorited: true).count
      }

      @practices_favorites = @enabled_published_practices.sort_by(&:current_month_favorited).reverse!

      @practices_comment_stats = {
          comments_this_month: Commontator::Comment.where(created_at: @beginning_of_current_month..@end_of_current_month).count,
          comments_one_month_ago: Commontator::Comment.where(created_at: @beginning_of_last_month..@end_of_last_month).count,
          total_comments: Commontator::Comment.count
      }

      @practices_commitment_stats = {
          committed_this_month: UserPractice.where(time_committed: @beginning_of_current_month..@end_of_current_month, committed: true).count,
          committed_one_month_ago: UserPractice.where(time_committed: @beginning_of_last_month..@end_of_last_month,committed: true).count,
          total_committed: UserPractice.where(committed: true).count
      }

      @approved_enabled_published_practices = Practice.where(published: true, enabled: true, approved: true).order(Arel.sql("lower(practices.name) ASC"))

      @practice_views_array = []
      @site_visits_by_month = []
      @total_users_by_month = []
      @new_users_by_month = []
      @month_and_year_array = []
      start_date = Date.today.prev_year.beginning_of_month
      end_date = Date.today

      while start_date <= end_date
        beg_of_month = start_date.beginning_of_day
        end_of_month = start_date.end_of_month.end_of_day
        month_and_year = Date::MONTHNAMES[start_date.month] + " #{ start_date.year.to_s}"
        # Get practice views by month
        @approved_enabled_published_practices.each do |p|
          practice_visits_by_month = []
          pr_visit_ct = Ahoy::Event.where_props(practice_id: p[:id]).where(time: beg_of_month...end_of_month).count
          practice_visits_by_month << pr_visit_ct
          practice_visits_by_month.each do |visit_count|
            @practice_views_array << [p.id, visit_count]
          end
        end

        # Get site visits by month
        site_visits = site_visits(beg_of_month, end_of_month)
        site_visit_ct = site_visits.sum {|_k, v| v}
        @site_visits_by_month << [month_and_year, site_visit_ct]

        # Get new users by month
        new_user_count = User.where(created_at: beg_of_month..end_of_month).count
        @new_users_by_month << new_user_count

        # Get total users by month
        total_user_count = User.where(current_sign_in_at: beg_of_month..end_of_month).count
        @total_users_by_month << total_user_count

        @month_and_year_array << [month_and_year]
        start_date += 1.months
      end

      # Assign the monthly practice views to the correct practice based on its id
      @practice_views_by_month = []
      @approved_enabled_published_practices.each do |p|
        @practice_views_array.each do |array|
          if p.id === array.first
            @practice_views_by_month << [p.name, array.last]
          end
        end
      end


      # Add user stats hash to make it easier to format spreadsheet data
      @user_statistics = {
          new_users: @new_users_by_month,
          total_users: @total_users_by_month
      }
    end

    def add_header_row_for_month_and_year(sheet, first_column_text, array, row_style)
      sheet_row = ["#{first_column_text}"] + array.map { |a| a.join(' ') }
      sheet.add_row sheet_row, style: row_style
    end

    def add_monthly_array_values_to_columns(hash, sheet, row_style)
      hash.each do |key, value|
        sheet_row = [key.to_s.tr!('_', ' ').titleize] + value.map { |v| v }
        sheet.add_row sheet_row, style: row_style
      end
    end

    def export_metrics
      metrics_xlsx_file = Axlsx::Package.new do |p|
        # styling
        s = p.workbook.styles
        adoption_xlsx_styles(p)
        xlsx_main_header = s.add_style sz: 16, alignment: { horizontal: :center }, bg_color: '005EA2', fg_color: 'FFFFFF'
        xlsx_sub_header_1 = s.add_style sz: 14, alignment: { horizontal: :center }, fg_color: '005EA2'
        xlsx_sub_header_2 = s.add_style sz: 12, alignment: { horizontal: :center }, bg_color: '585858', fg_color: 'FFFFFF'
        xlsx_sub_header_3 = s.add_style sz: 12, alignment: { horizontal: :center }, bg_color: 'F3F3F3', fg_color: '000000'
        xlsx_entry = s.add_style sz: 12, alignment: { horizontal: :left, vertical: :center, wrap_text: true}
        xlsx_divider = s.add_style sz: 12

        # building out xlsx file
        p.workbook.add_worksheet(:name => "DM Metrics - #{Date.today}") do |sheet|
          sheet.add_row ['Please Note'], style: @xlsx_legend_no_bottom_border
          sheet.add_row ['Adoptions and commits are defined by the following:'], style: @xlsx_legend_no_y_border
          sheet.add_row [''], style: xlsx_divider
          sheet.add_row ['Adoptions: Number of adoptions Practice Owner has added for Diffusion Map.'], style: @xlsx_legend_no_y_border
          sheet.add_row ['Commits: Number of users committed to practice through Diffusion Marketplace.'], style: @xlsx_legend_no_top_border
          sheet.merge_cells 'A1:C1'
          sheet.add_row [''], style: xlsx_divider
          sheet.add_row ["Diffusion Marketplace Metrics - #{Date.today}"], style: xlsx_main_header
          sheet.add_row ["General Traffic"], style: xlsx_sub_header_1
          @general_traffic_stats.each { |key, value| sheet.add_row [key.to_s === 'unique_visitors' || key.to_s === 'number_of_site_visits' ? key.to_s.tr!('_', ' ').titleize + ' (last month)' : key.to_s.tr!('_', ' ').titleize + ' (all-time)', value], style: xlsx_entry }
          sheet.add_row ['Site Visits per Month'], style: xlsx_sub_header_2
          @site_visits_by_month.each do |month_and_count|
            sheet.add_row [month_and_count[0], month_and_count[1]], style: xlsx_entry
          end
          sheet.add_row [""], style: xlsx_divider

          sheet.add_row ["Practices"], style: xlsx_sub_header_1
          @practices_added_stats.each { |key, value| sheet.add_row [key.to_s.tr!('_', ' ').titleize, value], style: xlsx_entry }
          sheet.add_row [""], style: xlsx_divider

          sheet.add_row ["Practice Engagement & Commitment"], style: xlsx_sub_header_1
          sheet.add_row ['Practice Views per Month'], style: xlsx_sub_header_2
          add_header_row_for_month_and_year(sheet, 'Practice name', @month_and_year_array, xlsx_sub_header_3)
          @practice_views_by_month.in_groups_of(13) do |practice_views|
            sheet_row = ["#{practice_views[0][0]}"] + practice_views.map { |pv| pv[1]}
            sheet.add_row sheet_row, style: xlsx_entry
          end
          sheet.add_row [''], style: xlsx_divider

          sheet.add_row ["Favorited Counts"], style: xlsx_sub_header_2
          @practices_favorited_stats.each { |key, value| sheet.add_row [key.to_s.tr!('_', ' ').titleize, value], style: xlsx_entry }
          sheet.add_row [""], style: xlsx_divider

          sheet.add_row ["Favorited Counts by Practice"], style: xlsx_sub_header_2
          sheet.add_row @practices_headers, style: xlsx_sub_header_3
          @practices.each do |value|
            sheet.add_row [
                              value.name,
                              value.current_month_favorited,
                              value.last_month_favorited,
                              value.favorited_count
                          ], style: xlsx_entry
          end
          sheet.add_row [""], style: xlsx_divider

          sheet.add_row ["Comment Counts"], style: xlsx_sub_header_2
          @practices_comment_stats.each { |key, value| sheet.add_row [key.to_s.tr!('_', ' ').titleize, value], style: xlsx_entry }
          sheet.add_row [""], style: xlsx_divider

          sheet.add_row ["Comment Counts by Practice"], style: xlsx_sub_header_2
          sheet.add_row @practices_headers, style: xlsx_sub_header_3
          @practices.each do |value|
            sheet.add_row [
                              value.name,
                              value.commontator_thread.comments.where(created_at: @beginning_of_current_month..@end_of_current_month).count,
                              value.commontator_thread.comments.where(created_at: @beginning_of_last_month..@end_of_last_month).count,
                              value.commontator_thread.comments.count
                          ], style: xlsx_entry
          end
          sheet.add_row [""], style: xlsx_divider

          sheet.add_row ["Commit Counts"], style: xlsx_sub_header_2
          @practices_commitment_stats.each { |key, value| sheet.add_row [key.to_s.tr!('_', ' ').titleize, value], style: xlsx_entry }
          sheet.add_row [""], style: xlsx_divider

          sheet.add_row ["Commit Counts by Practice"], style: xlsx_sub_header_2
          sheet.add_row @practices_headers, style: xlsx_sub_header_3
          @practices.each do |value|
            sheet.add_row [
                value.name,
                value.current_month_commits,
                value.last_month_commits,
                value.commits_count
            ], style: xlsx_entry
          end
          sheet.add_row [""], style: xlsx_divider

          sheet.add_row ['User Statistics'], style: xlsx_sub_header_1
          sheet.add_row ['Users per Month'], style: xlsx_sub_header_2
          add_header_row_for_month_and_year(sheet, '', @month_and_year_array, xlsx_sub_header_3)
          add_monthly_array_values_to_columns(@user_statistics, sheet, xlsx_entry)
        end
      end

      # generating downloadable .xlsx file
      send_data metrics_xlsx_file.to_stream.read, :filename => "dm_metrics_#{Date.today}.xlsx", :type => "application/xlsx"
    end
  end

  content title: proc {I18n.t("active_admin.dashboard")} do
    enabled_published_practices = Practice.where(enabled: true, published: true)
    div(class: 'dashboard-legend-container') do
      div(class: 'dashboard-legend') do
        h3 do
          'Please Note'
        end
        h4 do
          span 'Adoptions '
          span 'and '
          span 'commits '
          span 'are defined by the following:'
        end
        ul do
          li do
            span 'Adoptions: '
            span 'Number of adoptions Practice Owner has added for Diffusion Map.'
          end
          li do
            span 'Commits: '
            span 'Number of users committed to practice through Diffusion Marketplace.'
          end
        end
      end
    end
    tabs do
      tab :users_information do
        columns do
          column do
            panel 'New Users This Month' do
              column_chart User.where('created_at >= ?', 1.week.ago).group_by_month(:created_at, format: '%b').count, ytitle: 'Users'
            end

            panel 'New Users by Month' do
              column_chart User.group_by_month(:current_sign_in_at, format: '%b').count, ytitle: 'Users'
            end
          end # column
        end # columns
        user_info = [{
                         in_the_last: 'New Users',
                         '24_hours': User.where('created_at >= ?', 1.day.ago).count,
                         week: User.where('created_at >= ?', 1.week.ago).count,
                         month: User.where('created_at >= ?', 1.month.ago).count,
                         three_months: User.where('created_at >= ?', 3.months.ago).count,
                         year: User.where('created_at >= ?', 1.year.ago).count
                     }, {
                         in_the_last: 'Total Users',
                         '24_hours': User.where('current_sign_in_at >= ?', 1.day.ago).count,
                         week: User.where('current_sign_in_at >= ?', 1.week.ago).count,
                         month: User.where('current_sign_in_at >= ?', 1.month.ago).count,
                         three_months: User.where('current_sign_in_at >= ?', 3.months.ago).count,
                         year: User.where('current_sign_in_at >= ?', 1.year.ago).count
                     }]
        columns do
          column do
            panel 'User statistics' do
              table_for user_info do |_info|
                column :in_the_last
                column :'24_hours'
                column :week
                column :month
                column :three_months
                column :year
              end
            end
          end # column
        end # columns
      end # tab

      tab :practice_leaderboards do
        columns do
          column do
            panel "Practice Views Leaderboard" do
              table_for practices_views.each, id: 'practice-views-table' do
                column(:name) {|practice| link_to(practice.name, admin_practice_path(practice))}
                column("#{date_headers[:current]}") {|practice| practice.current_month_views}
                column("#{date_headers[:one_month_ago]}") {|practice| practice.last_month_views}
                column("#{date_headers[:two_month_ago]}") {|practice| practice.two_months_ago_views}
                column("#{date_headers[:three_month_ago]}") {|practice| practice.three_months_ago_views}
                column("Total lifetime views") {|practice| practice.views}
              end

              script do
                total_current_month_views = enabled_published_practices.sum(&:current_month_views)
                total_last_month_views = enabled_published_practices.sum(&:last_month_views)
                total_two_months_ago_views = enabled_published_practices.sum(&:two_months_ago_views)
                total_three_months_ago_views = enabled_published_practices.sum(&:three_months_ago_views)
                total_lifetime_views = enabled_published_practices.sum(&:views)
                raw "$(document).ready(function($) {
                        $('#practice-views-table').append('<tr><td><b>Totals</b></td><td><b>#{total_current_month_views}</b></td><td><b>#{total_last_month_views}</b></td><td><b>#{total_two_months_ago_views}</b></td><td><b>#{total_three_months_ago_views}</b></td><td><b>#{total_lifetime_views}</b></td></tr>');
                      });
                    "
              end
            end

            panel "Practice Commits Leaderboard" do
              table_for practices_views.each, id: 'practice-commits-table' do
                column(:name) {|practice| link_to(practice.name, admin_practice_path(practice))}
                column("#{date_headers[:current]}") {|practice| practice.committed_user_count_by_range(beginning_of_current_month, end_of_current_month)}
                column("#{date_headers[:one_month_ago]}") {|practice| practice.committed_user_count_by_range(beginning_of_last_month, end_of_last_month)}
                column("#{date_headers[:two_month_ago]}") {|practice| practice.committed_user_count_by_range(beginning_of_two_months_ago, end_of_two_months_ago)}
                column("#{date_headers[:three_month_ago]}") {|practice| practice.committed_user_count_by_range(beginning_of_three_months_ago, end_of_three_months_ago)}
                column("Total lifetime commits") {|practice| practice.committed_user_count}
              end

              script do
                total_current_month_commits = enabled_published_practices.sum(&:current_month_commits)
                total_last_month_commits = enabled_published_practices.sum(&:last_month_commits)
                total_two_months_ago_commits = enabled_published_practices.sum(&:two_months_ago_commits)
                total_three_months_ago_commits = enabled_published_practices.sum(&:three_months_ago_commits)
                total_lifetime_commits = enabled_published_practices.sum(&:committed_user_count)
                raw "$(document).ready(function($) {
                        $('#practice-commits-table').append('<tr><td><b>Totals</b></td><td><b>#{total_current_month_commits}</b></td><td><b>#{total_last_month_commits}</b></td><td><b>#{total_two_months_ago_commits}</b></td><td><b>#{total_three_months_ago_commits}</b></td><td><b>#{total_lifetime_commits}</b></td></tr>');
                      });
                    "
              end
            end
          end # column
        end # columns
      end # tab

      tab :'Practice search terms' do
        h3 do
          "List of all practice search terms sorted by the current month's hits"
        end

        search_terms = []
        events = Ahoy::Event.where(name: 'Practice search').where("properties->>'search_term' is not null").group("properties->>'search_term'").order('count_all desc').count
        events.each do |e|
          search_terms << {
              query: e[0],
              lifetime_count: e[1],
              current_month_count: Ahoy::Event.count_for_range(beginning_of_current_month, end_of_current_month, e[0]),
              last_month_count: Ahoy::Event.count_for_range(beginning_of_last_month, end_of_last_month, e[0]),
              two_months_ago_count: Ahoy::Event.count_for_range(beginning_of_two_months_ago, end_of_two_months_ago, e[0]),
              three_months_ago_count: Ahoy::Event.count_for_range(beginning_of_three_months_ago, end_of_three_months_ago, e[0]),
          }
        end

        search_terms.sort_by {|k| k["current_month_count"]}.reverse!

        columns do
          column do
            table_for search_terms.each, id: 'practice-search-terms-table' do
              column('Term') {|st| st[:query]}
              column("#{date_headers[:current]}") {|st| st[:current_month_count]}
              column("#{date_headers[:one_month_ago]}") {|st| st[:last_month_count]}
              column("#{date_headers[:two_month_ago]}") {|st| st[:two_months_ago_count]}
              column("#{date_headers[:three_month_ago]}") {|st| st[:three_months_ago_count]}
              column("Lifetime") {|st| st[:lifetime_count]}
            end
          end
        end

        script do
          total_current_month_searches = search_terms.sum {|st| st[:current_month_count] }
          total_last_month_searches = search_terms.sum {|st| st[:last_month_count]}
          total_two_months_ago_searches = search_terms.sum {|st| st[:two_months_ago_count]}
          total_three_months_ago_searches = search_terms.sum {|st| st[:three_months_ago_count]}
          total_lifetime_searches = search_terms.sum {|st| st[:lifetime_count]}
          raw "$(document).ready(function($) {
                        $('#practice-search-terms-table').append('<tr><td><b>Totals</b></td><td><b>#{total_current_month_searches}</b></td><td><b>#{total_last_month_searches}</b></td><td><b>#{total_two_months_ago_searches}</b></td><td><b>#{total_three_months_ago_searches}</b></td><td><b>#{total_lifetime_searches}</b></td></tr>');
                      });
                    "
        end

        script do
          raw "$(document).ready(function(){$('tr').attr('id', '')});"
        end
      end # tab

      tab :metrics do
        # export .xlsx button
        form action: export_metrics_path, method: :get, style: 'text-align: right' do |f|
          f.input :submit, type: :submit, value: 'Export as .xlsx', style: 'margin-bottom: 1rem'
        end

        panel 'General Traffic' do
          table_for general_traffic_stats do
            column('unique visitors (last month)', :unique_visitors)
            column('number of site visits (last month)', :number_of_site_visits)
            column('total accounts (all-time)', :total_accounts)
          end
        end # panel

        panel 'Practices' do
          table_for practices_added_stats do
            column("#{date_headers[:current]}") {|ps| ps[:added_this_month]}
            column("Last Month") {|ps| ps[:added_one_month_ago]}
            column :total_practices_created
          end
        end # panel

        panel 'Practice Engagement & Commitment' do
          h4 do
            "Favorited Counts"
          end

          table_for practices_favorited_stats, id: 'favorited_stats' do
            column("#{date_headers[:current]}") {|ps| ps[:favorited_this_month]}
            column("Last Month") {|ps| ps[:favorited_one_month_ago]}
            column :total_favorited
          end
          h4 do
            "Favorited Counts by Practice"
          end

          table_for practices do
            column(:name) {|pr| link_to(pr.name, admin_practice_path(pr))}
            column("#{date_headers[:current]}") {|pr| pr.current_month_favorited}
            column("Last Month") {|pr| pr.last_month_favorited}
            column("#{date_headers[:total]}") {|pr| pr.favorited_count}
          end

          h4 do
            "Comment Counts"
          end

          table_for practices_comment_stats do
            column("#{date_headers[:current]}") {|ps| ps[:comments_this_month]}
            column("Last Month") {|ps| ps[:comments_one_month_ago]}
            column :total_comments
          end

          h4 do
            "Comment Counts by Practice"
          end

          table_for practices do
            column(:name) {|pr| link_to(pr.name, admin_practice_path(pr))}
            column("#{date_headers[:current]}") {|pr| pr.commontator_thread.comments.where(created_at: beginning_of_current_month...end_of_current_month).count}
            column("Last Month") {|pr| pr.commontator_thread.comments.where(created_at: beginning_of_last_month...end_of_last_month).count}
            column("#{date_headers[:total]}") {|pr| pr.commontator_thread.comments.count}
          end

          h4 do
            "Commit Counts"
          end

          table_for practices_commitment_stats, id: 'adopted_stats' do
            column("#{date_headers[:current]}") {|ps| ps[:committed_this_month]}
            column("Last Month") {|ps| ps[:committed_one_month_ago]}
            column :total_committed
          end

          h4 do
            "Commit Counts by Practice"
          end

          table_for practices do
            column(:name) {|pr| link_to(pr.name, admin_practice_path(pr))}
            column("#{date_headers[:current]}") {|pr| pr.current_month_commits}
            column("Last Month") {|pr| pr.last_month_commits}
            column("#{date_headers[:total]}") {|pr| pr.commits_count}
          end
        end # panel
      end # tab
    end # tabs
  end # content
end # register_page