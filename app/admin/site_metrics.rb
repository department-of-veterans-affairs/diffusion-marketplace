include ActiveAdminHelpers

ActiveAdmin.register_page 'Site Metrics' do
  menu false
  # menu label: proc {I18n.t('active_admin.site_metrics')}

  controller do
    helper_method :set_date_values
    helper_method :adoption_xlsx_styles
    before_action :set_metrics_values

    def get_custom_pages_stats(custom_pages)
      traffic_stats = []
      custom_pages.each do |cp|
        is_homepage = cp[:slug] === 'home'
        visit_count_by_ip_address_for_last_month = is_homepage ?
                                                     Ahoy::Event.custom_page_homepage_visits_by_date_range(cp, @beginning_of_last_month, @end_of_last_month).count :
                                                     Ahoy::Event.custom_page_subpage_visits_by_date_range(cp, @beginning_of_last_month, @end_of_last_month).count

        slug = is_homepage ? cp[:group] : "#{cp[:group]}/#{cp[:slug]}"
        prop = {
          slug: slug,
          unique_visitors_for_last_month: 0,
          number_of_page_views_for_last_month: 0,
          total_views: is_homepage ? Ahoy::Event.custom_page_homepage_visits(cp).count : Ahoy::Event.custom_page_subpage_visits(cp).count
        }

        unless visit_count_by_ip_address_for_last_month.blank?
          prop[:unique_visitors_for_last_month] = visit_count_by_ip_address_for_last_month.keys.length
          prop[:number_of_page_views_for_last_month] = visit_count_by_ip_address_for_last_month.sum {|_k, v| v}
        end

        traffic_stats.push(prop)
      end
      traffic_stats.sort_by { |pg| pg[:slug] }
    end

    def set_metrics_values
      set_date_values
      @published_enabled_approved_practices = Practice.cached_published_enabled_approved_practices
      @practices_sorted_by_name = @published_enabled_approved_practices.sort_a_to_z.pluck(:id, :name)

      # Page Builder Stats
      @custom_pages = Page.all.map { |pg| {slug: pg.slug, group: PageGroup.find_by(id: pg.page_group_id).slug } }
      @custom_pages_traffic_stats = get_custom_pages_stats(@custom_pages)

      # User Info
      @user_info = [
        {
          in_the_last: 'New Users',
          '24_hours': User.created_by_date_or_earlier(1.day.ago).count,
          week: User.created_by_date_or_earlier(1.week.ago).count,
          month: User.created_by_date_or_earlier(1.month.ago).count,
          three_months: User.created_by_date_or_earlier(3.months.ago).count,
          year: User.created_by_date_or_earlier(1.year.ago).count
        },
        {
          in_the_last: 'Unique User Visits',
          '24_hours': Ahoy::Event.site_visits_by_unique_users_and_date_or_earlier(1.day.ago).group(:user_id).count.keys.length,
          week: Ahoy::Event.site_visits_by_unique_users_and_date_or_earlier(1.week.ago).group(:user_id).count.keys.length,
          month: Ahoy::Event.site_visits_by_unique_users_and_date_or_earlier(1.month.ago).group(:user_id).count.keys.length,
          three_months: Ahoy::Event.site_visits_by_unique_users_and_date_or_earlier(3.months.ago).group(:user_id).count.keys.length,
          year: Ahoy::Event.site_visits_by_unique_users_and_date_or_earlier(1.year.ago).group(:user_id).count.keys.length
        }
      ]

      # General Site Metrics
      site_visit_stats_for_last_month = Ahoy::Event.site_visits_by_date_range(@beginning_of_last_month, @end_of_last_month).group("properties->>'ip_address'").count

      @general_traffic_stats = {
        unique_visitors: site_visit_stats_for_last_month.keys.length,
        number_of_page_views: site_visit_stats_for_last_month.sum {|_k, v| v},
        total_accounts: User.all.count
      }

      @practices_added_stats = {
        added_this_month: @published_enabled_approved_practices.where(created_at: @beginning_of_current_month..@end_of_current_month).count,
        added_one_month_ago: @published_enabled_approved_practices.where(created_at: @beginning_of_last_month..@end_of_last_month).count,
        total_innovations_created: @published_enabled_approved_practices.count
      }

      @practices_favorited_stats = {
        favorited_this_month: UserPractice.favorited_by_date_range(@beginning_of_current_month, @end_of_current_month).count,
        favorited_one_month_ago: UserPractice.favorited_by_date_range(@beginning_of_last_month, @end_of_last_month).count,
        total_favorited: UserPractice.favorited.count
      }

      @practices_emailed = {
        emails_this_month: Ahoy::Event.practice_emails_excluding_null_practice_id.by_date_range(@beginning_of_current_month, @end_of_current_month).count,
        emails_one_month_ago: Ahoy::Event.practice_emails_excluding_null_practice_id.by_date_range(@beginning_of_last_month, @end_of_last_month).count,
        total_emails: Ahoy::Event.practice_emails.count
      }

      # Individual Practice Metrics
      @practice_stats = []
      @practices_sorted_by_name.each do |practice|
        @practice_stats << {
          practice: practice,
          emails: {
            current_month: Ahoy::Event.practice_emails_for_practice_by_date_range(practice.first, @beginning_of_current_month, @end_of_current_month).count,
            last_month: Ahoy::Event.practice_emails_for_practice_by_date_range(practice.first, @beginning_of_last_month, @end_of_last_month).count,
            all_time: Ahoy::Event.practice_emails_for_practice(practice.first).count
          },
          comments: {
            current_month: Commontator::Comment.get_by_practice_and_date_range(practice.first, @beginning_of_current_month, @end_of_current_month).count,
            last_month: Commontator::Comment.get_by_practice_and_date_range(practice.first, @beginning_of_last_month, @end_of_last_month).count,
            all_time: Commontator::Comment.get_by_practice(practice.first).count
          },
          bookmarks: {
            current_month: UserPractice.get_by_practice_and_favorited_date_range(practice.first, @beginning_of_current_month, @end_of_current_month).count,
            last_month: UserPractice.get_by_practice_and_favorited_date_range(practice.first, @beginning_of_last_month, @end_of_last_month).count,
            all_time: UserPractice.get_by_practice_and_favorited(practice.first).count
          }
        }
      end

      @practices_comment_stats = {
        comments_this_month: Commontator::Comment.created_by_date_range(@beginning_of_current_month, @end_of_current_month).count,
        comments_one_month_ago: Commontator::Comment.created_by_date_range(@beginning_of_last_month, @end_of_last_month).count,
        total_comments: Commontator::Comment.all.count
      }

      # Monthly metrics
      @practice_views_array = []
      @site_visits_by_month = []
      @total_users_by_month = []
      @new_users_by_month = []
      @month_and_year_array = []
      @new_users = {}
      @user_visitors = {}

      start_date = Date.today.prev_year.beginning_of_month
      end_date = Date.today

      while start_date <= end_date
        beg_of_month = start_date.beginning_of_day
        end_of_month = start_date.end_of_month.end_of_day
        month_and_year = Date::MONTHNAMES[start_date.month] + " #{ start_date.year.to_s}"
        # Get practice views by month
        @practices_sorted_by_name.each do |p|
          pr_visit_ct = Ahoy::Event.practice_views_for_single_practice_by_date_range(p.first, beg_of_month, end_of_month).count
          @practice_views_array << [p.last, pr_visit_ct]
        end

        # Get users info by month
        @new_users[month_and_year] = User.where(created_at: beg_of_month..end_of_month).count
        @user_visitors[month_and_year] = Ahoy::Event.site_visits.exclude_null_ips_and_duplicates.where.not(user_id: nil).by_date_range(beg_of_month, end_of_month).group(:user_id).count.keys.length

        # Get site visits by month
        site_visits = Ahoy::Event.site_visits_by_date_range(beg_of_month, end_of_month).group("properties->>'ip_address'").count
        site_visit_ct = site_visits.sum {|_k, v| v}
        @site_visits_by_month << [month_and_year, site_visit_ct]
        @month_and_year_array << [month_and_year]
        start_date += 1.months
      end

      # group the practice views by month by practice name
      @practice_views_by_month = @practice_views_array.group_by { |p| p[0] }

      # Add user stats hash to make it easier to format spreadsheet data
      @user_statistics = {
        new_users: @new_users.values,
        total_users: @user_visitors.values
      }

      @practices_headers = ['Practice Name', "#{@date_headers[:current]}", "Last Month", "#{@date_headers[:total]}"]
    end

    def add_header_row_for_month_and_year(sheet, first_column_text, array, row_style)
      sheet_row = ["#{first_column_text}"] + array.reverse.map { |a| a.join(' ') }
      sheet.add_row sheet_row, style: row_style
    end

    def add_monthly_array_values_to_columns(hash, sheet, row_style)
      hash.each do |key, value|
        sheet_row = [key.to_s.tr!('_', ' ').titleize] + value.reverse.map { |v| v }
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
          sheet.add_row ['Adoptions and users are defined by the following:'], style: @xlsx_legend_no_y_border
          sheet.add_row [''], style: xlsx_divider
          sheet.add_row ['Adoptions: Number of adoptions Practice Owner has added for Diffusion Map.'], style: @xlsx_legend_no_y_border
          sheet.add_row ['Users: Unique visitors to Diffusion Marketplace'], style: @xlsx_legend_no_top_border
          sheet.merge_cells 'A1:C1'
          sheet.add_row [''], style: xlsx_divider
          sheet.add_row ["Diffusion Marketplace Metrics - #{Date.today}"], style: xlsx_main_header
          sheet.add_row ["General Traffic"], style: xlsx_sub_header_1
          @general_traffic_stats.each do |key, value|
            sheet.add_row [
              key.to_s === 'unique_visitors' || key.to_s === 'number_of_page_views' ?
                "#{key.to_s.tr!('_', ' ').titleize} (last month)" :
                "#{key.to_s.tr!('_', ' ').titleize} (all-time)", value
            ], style: xlsx_entry
          end
          sheet.add_row ['Site Visits per Month'], style: xlsx_sub_header_2
          @site_visits_by_month.reverse.each do |month_and_count|
            sheet.add_row [month_and_count[0], month_and_count[1]], style: xlsx_entry
          end
          sheet.add_row [""], style: xlsx_divider
          if @custom_pages.present?
            sheet.add_row ["Custom Page Traffic"], style: xlsx_sub_header_1
            sheet.add_row ['Page', 'Unique Visitors (last month)', 'Number Of Page Views (last month)', 'Total Page Views (all-time)'], style: xlsx_sub_header_3
            @custom_pages_traffic_stats.each do |stat|
              sheet.add_row [stat[:slug], stat[:unique_visitors_for_last_month], stat[:number_of_page_views_for_last_month], stat[:total_views]], style: xlsx_entry
            end
            sheet.add_row [""], style: xlsx_divider
          end
          sheet.add_row ["Innovations"], style: xlsx_sub_header_1
          @practices_added_stats.each { |key, value| sheet.add_row [key.to_s.tr!('_', ' ').titleize, value], style: xlsx_entry }
          sheet.add_row [""], style: xlsx_divider

          sheet.add_row ["Innovation Engagement"], style: xlsx_sub_header_1
          sheet.add_row ['Innovation Views per Month'], style: xlsx_sub_header_2
          add_header_row_for_month_and_year(sheet, 'Innovation name', @month_and_year_array, xlsx_sub_header_3)
          @practice_views_by_month.each do |practice_views|
            sheet_row = ["#{practice_views.first}"] + practice_views.last.reverse.map { |pv| pv[1] }
            sheet.add_row sheet_row, style: xlsx_entry
          end
          sheet.add_row [''], style: xlsx_divider
          # Bookmarks
          sheet.add_row ["Bookmarked Counts"], style: xlsx_sub_header_2
          @practices_favorited_stats.each { |key, value| sheet.add_row [key.to_s.tr!('_', ' ').titleize, value], style: xlsx_entry }
          sheet.add_row [""], style: xlsx_divider
          sheet.add_row ["Bookmarked Counts by Innovation"], style: xlsx_sub_header_2
          sheet.add_row @practices_headers, style: xlsx_sub_header_3
          @practice_stats.each do |pr_hash|
            sheet.add_row [
              pr_hash[:practice].last,
              pr_hash[:bookmarks][:current_month],
              pr_hash[:bookmarks][:last_month],
              pr_hash[:bookmarks][:all_time]
            ], style: xlsx_entry
          end
          sheet.add_row [""], style: xlsx_divider
          # Comments
          sheet.add_row ["Comment Counts"], style: xlsx_sub_header_2
          @practices_comment_stats.each { |key, value| sheet.add_row [key.to_s.tr!('_', ' ').titleize, value], style: xlsx_entry }
          sheet.add_row [""], style: xlsx_divider
          sheet.add_row ["Comment Counts by Innovation"], style: xlsx_sub_header_2
          sheet.add_row @practices_headers, style: xlsx_sub_header_3
          @practice_stats.each do |pr_hash|
            sheet.add_row [
              pr_hash[:practice].last,
              pr_hash[:comments][:current_month],
              pr_hash[:comments][:last_month],
              pr_hash[:comments][:all_time]
            ], style: xlsx_entry
          end
          sheet.add_row [""], style: xlsx_divider
          # Emails
          sheet.add_row ["Email Counts"], style: xlsx_sub_header_2
          @practices_emailed.each { |key, value| sheet.add_row [key.to_s.tr!('_', ' ').titleize, value], style: xlsx_entry }
          sheet.add_row [""], style: xlsx_divider
          sheet.add_row ["Email Counts by Innovation"], style: xlsx_sub_header_2
          sheet.add_row @practices_headers, style: xlsx_sub_header_3
          @practice_stats.each do |pr_hash|
            sheet.add_row [
              pr_hash[:practice].last,
              pr_hash[:emails][:current_month],
              pr_hash[:emails][:last_month],
              pr_hash[:emails][:all_time]
            ], style: xlsx_entry
          end
          sheet.add_row [""], style: xlsx_divider
          # User stats
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

  content title: proc {I18n.t("active_admin.site_metrics")} do
    div(class: 'position-relative') do
      # export .xlsx button
      form action: export_metrics_path, method: :get, style: 'text-align: left' do |f|
        f.input :submit, type: :submit, value: 'Export as .xlsx', class: 'margin-bottom-2'
      end

      div(class: 'site-metrics-legend bottom-2') do
        h3 do
          'Please Note'
        end
        h4 do
          span('Adoptions', class: 'dm-text-bold')
          span 'and '
          span('users', class: 'dm-text-bold')
          span 'are defined as the following:'
        end
        ul do
          li do
            span('Adoptions:', class: 'dm-text-bold')
            span 'Number of adoptions Innovation Owner has added for Diffusion Map'
          end
          li do
            span('Users:', class: 'dm-text-bold')
            span 'Unique visitors to Diffusion Marketplace'
          end
        end
      end
    end

    tabs do
      tab :'General' do
        panel 'General Traffic' do
          span("Note: An error in general traffic tracking was corrected in February 2021")
          table_for general_traffic_stats do
            column('unique visitors (last month)', :unique_visitors)
            column('number of page views (last month)', :number_of_page_views)
            column('total accounts (all-time)', :total_accounts)
          end
        end # panel

        if custom_pages.present?
          panel('Custom Page Traffic', class: 'dm-panel-container', id: 'dm-custom-page-traffic') do
            span("Note: Custom page traffic tracking began in February 2021")
            table_for custom_pages_traffic_stats do
              column("Page") {|pg| link_to(pg[:slug], "/#{pg[:slug]}")}
              column('unique visitors (last month)', class: 'col-unique_visitors_custom_page') {|pg| pg[:unique_visitors_for_last_month]}
              column('number of page views (last month)', class: 'col-page_views_custom_page') {|pg| pg[:number_of_page_views_for_last_month]}
              column('total page views (all-time)', class: 'col-total_views_custom_page') {|pg| pg[:total_views]}
            end
          end # panel
        end

        panel 'Innovations Created' do
          table_for practices_added_stats do
            column("#{date_headers[:current]}") {|ps| ps[:added_this_month]}
            column("Last Month") {|ps| ps[:added_one_month_ago]}
            column :total_innovations_created
          end
        end # panel
      end # tab

      tab :'Innovation Engagement' do
        panel 'Bookmarks' do
          h4("Bookmarked Counts", title: "Number of times an innovation was bookmarked", class: "dm-tooltip")

          table_for practices_favorited_stats, id: 'favorited_stats' do
            column("#{date_headers[:current]}") {|ps| ps[:favorited_this_month]}
            column("Last Month") {|ps| ps[:favorited_one_month_ago]}
            column :total_favorited
          end

          h4("Bookmarked Counts by Innovation", title: "Number of times each innovation has been bookmarked", class: "dm-tooltip")

          table_for practice_stats, id: 'favorited-stats-by-practice' do
            column(:name) { |pr_hash| link_to(pr_hash[:practice].last, admin_practice_path(pr_hash[:practice].first)) }
            column("#{date_headers[:current]}") { |pr_hash| pr_hash[:bookmarks][:current_month] }
            column("Last Month") { |pr_hash| pr_hash[:bookmarks][:last_month] }
            column("#{date_headers[:total]}") { |pr_hash| pr_hash[:bookmarks][:all_time] }
          end
        end # panel

        panel 'Comments' do
          h4("Comment Counts", title: "Number of comments made this month, last month, and overall on any innovation page", class: "dm-tooltip")

          table_for practices_comment_stats, id: 'comment-stats' do
            column("#{date_headers[:current]}") {|ps| ps[:comments_this_month]}
            column("Last Month") {|ps| ps[:comments_one_month_ago]}
            column :total_comments
          end

          h4("Comment Counts by Innovation", title: "Number of comments on each innovation page", class: "dm-tooltip")

          table_for practice_stats, id: 'comment-stats-by-practice' do
            column(:name) { |pr_hash| link_to(pr_hash[:practice].last, admin_practice_path(pr_hash[:practice].first)) }
            column("#{date_headers[:current]}") { |pr_hash| pr_hash[:comments][:current_month] }
            column("Last Month") { |pr_hash| pr_hash[:comments][:last_month] }
            column("#{date_headers[:total]}") { |pr_hash| pr_hash[:comments][:all_time] }
          end
        end # panel

        panel 'Emails' do
          h4("Email Counts", title: "Number of times an innovation was emailed via the innovation page this month, last month, and overall", class: "dm-tooltip")
          span("Note: Email counts tracking began in February 2021")

          table_for(practices_emailed, id: "dm-practices-emailed-total") do
            column("#{date_headers[:current]}") {|pe| pe[:emails_this_month]}
            column("Last Month") {|pe| pe[:emails_one_month_ago]}
            column :total_emails
          end

          h4("Email Counts by Innovation", title: "Number of times an innovation was emailed via the innovation page for each innovation", class: "dm-tooltip")

          table_for(practice_stats, id: "dm-practices-emailed-by-practice") do
            column(:name) { |pr_hash| link_to(pr_hash[:practice].last, admin_practice_path(pr_hash[:practice].first)) }
            column("#{date_headers[:current]}") { |pr_hash| pr_hash[:emails][:current_month] }
            column("Last Month") { |pr_hash| pr_hash[:emails][:last_month] }
            column("#{date_headers[:total]}") { |pr_hash| pr_hash[:emails][:all_time] }
          end
        end # panel
        #TODO: add practice email counts
      end # tab

      tab :'Users', id: 'users-tab' do
        columns do
          column do
            panel('New Users by Month', class: 'dm-panel-container', id: 'dm-new-users-by-month') do
              column_chart new_users.reverse_each.to_h, ytitle: 'Users'
            end
            panel('Unique User Visits by Month', class: 'dm-panel-container', id: 'dm-user-visits-by-month') do
              column_chart user_visitors.reverse_each.to_h, ytitle: 'Users'
            end
          end # column
        end # column

        columns do
          column do
            panel 'User Statistics', id: 'user-stats-panel' do
              table_for user_info.each do
                column(:in_the_last) { |info|
                  span(
                    info[:in_the_last],
                    class: "dm-tooltip",
                    title: info[:in_the_last] === 'New Users' ?
                             'Number of first time visitors to the site within the specified time period' :
                             'Number of unique user visits to the site within the specified time period'
                  )
                }
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
    end # tabs
  end
end
