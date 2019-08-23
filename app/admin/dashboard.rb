ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc {I18n.t("active_admin.dashboard")}

  content title: proc {I18n.t("active_admin.dashboard")} do

    @beginning_of_current_month = Date.today.at_beginning_of_month
    @end_of_current_month = Date.today.at_end_of_month
    @beginning_of_last_month = (Date.today - 1.months).at_beginning_of_month
    @end_of_last_month = (Date.today - 1.months).at_end_of_month
    @beginning_of_two_months_ago = (Date.today - 2.months).at_beginning_of_month
    @end_of_two_months_ago = (Date.today - 2.months).at_end_of_month
    @beginning_of_three_months_ago = (Date.today - 3.months).at_beginning_of_month
    @end_of_three_months_ago = (Date.today - 3.months).at_end_of_month

    tabs do
      tab :users_information do
        columns do
          column do
            panel 'New user signups by month' do
              column_chart User.where('created_at >= ?', 1.week.ago).group_by_month(:created_at, format: '%b').count, ytitle: 'Users'
            end

            panel 'Users signed in by month' do
              column_chart User.group_by_month(:current_sign_in_at, format: '%b').count, ytitle: 'Users'
            end
          end # column
        end # columns
        user_info = [{
                         in_the_last: 'New user signups',
                         '24_hours': User.where('created_at >= ?', 1.day.ago).count,
                         week: User.where('created_at >= ?', 1.week.ago).count,
                         month: User.where('created_at >= ?', 1.month.ago).count,
                         three_months: User.where('created_at >= ?', 3.months.ago).count,
                         year: User.where('created_at >= ?', 1.year.ago).count
                     }, {
                         in_the_last: 'Users signed in',
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
              practice_views = Practice.all.sort_by(&:current_month_views).reverse!

              table_for practice_views.each, id: 'practice-views-table' do
                column(:name) {|practice| link_to(practice.name, admin_practice_path(practice))}
                column("#{@beginning_of_current_month.strftime('%B %Y')} - current month") {|practice| practice.current_month_views}
                column("#{@beginning_of_last_month.strftime('%B %Y')} - last month") {|practice| practice.last_month_views}
                column("#{@beginning_of_two_months_ago.strftime('%B %Y')} - 2 months ago") {|practice| practice.two_months_ago_views}
                column("#{@beginning_of_three_months_ago.strftime('%B %Y')} - 3 months ago") {|practice| practice.three_months_ago_views}
                column("Total lifetime views") {|practice| practice.views}
              end

              script do
                total_current_month_views = Practice.all.sum(&:current_month_views)
                total_last_month_views = Practice.all.sum(&:last_month_views)
                total_two_months_ago_views = Practice.all.sum(&:two_months_ago_views)
                total_three_months_ago_views = Practice.all.sum(&:three_months_ago_views)
                total_lifetime_views = Practice.all.sum(&:views)
                raw "$(document).ready(function($) {
                        $('#practice-views-table').append('<tr><td><b>Totals</b></td><td><b>#{total_current_month_views}</b></td><td><b>#{total_last_month_views}</b></td><td><b>#{total_two_months_ago_views}</b></td><td><b>#{total_three_months_ago_views}</b></td><td><b>#{total_lifetime_views}</b></td></tr>');
                      });
                    "
              end

            end

            panel "Practice Commits Leaderboard" do
              practice_commits = Practice.all.sort_by(&:current_month_views).reverse!

              table_for practice_commits.each, id: 'practice-commits-table' do
                column(:name) {|practice| link_to(practice.name, admin_practice_path(practice))}
                column("#{@beginning_of_current_month.strftime('%B %Y')} - current month") {|practice| practice.committed_user_count_by_range(@beginning_of_current_month, @end_of_current_month)}
                column("#{@beginning_of_last_month.strftime('%B %Y')} - last month") {|practice| practice.committed_user_count_by_range(@beginning_of_last_month, @end_of_last_month)}
                column("#{@beginning_of_two_months_ago.strftime('%B %Y')} - 2 months ago") {|practice| practice.committed_user_count_by_range(@beginning_of_two_months_ago, @end_of_two_months_ago)}
                column("#{@beginning_of_three_months_ago.strftime('%B %Y')} - 3 months ago") {|practice| practice.committed_user_count_by_range(@beginning_of_three_months_ago, @end_of_three_months_ago)}
                column("Total lifetime commits") {|practice| practice.committed_user_count}
              end

              script do
                total_current_month_commits = Practice.all.sum(&:current_month_commits)
                total_last_month_commits = Practice.all.sum(&:last_month_commits)
                total_two_months_ago_commits = Practice.all.sum(&:two_months_ago_commits)
                total_three_months_ago_commits = Practice.all.sum(&:three_months_ago_commits)
                total_lifetime_commits = Practice.all.sum(&:committed_user_count)
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
              current_month_count: Ahoy::Event.count_for_range(@beginning_of_current_month, @end_of_current_month, e[0]),
              last_month_count: Ahoy::Event.count_for_range(@beginning_of_last_month, @end_of_last_month, e[0]),
              two_months_ago_count: Ahoy::Event.count_for_range(@beginning_of_two_months_ago, @end_of_two_months_ago, e[0]),
              three_months_ago_count: Ahoy::Event.count_for_range(@beginning_of_three_months_ago, @end_of_three_months_ago, e[0]),
          }
        end

        search_terms.sort_by {|k| k["current_month_count"]}.reverse!

        columns do
          column do
            table_for search_terms.each, id: 'practice-search-terms-table' do
              column('Term') {|st| st[:query]}
              column("#{@beginning_of_current_month.strftime('%B %Y')} - current month") {|st| st[:current_month_count]}
              column("#{@beginning_of_last_month.strftime('%B %Y')} - last month") {|st| st[:last_month_count]}
              column("#{@beginning_of_two_months_ago.strftime('%B %Y')} - 2 months ago") {|st| st[:two_months_ago_count]}
              column("#{@beginning_of_three_months_ago.strftime('%B %Y')} - 3 months ago") {|st| st[:three_months_ago_count]}
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
    end # tabs
  end # content
end # register_page

