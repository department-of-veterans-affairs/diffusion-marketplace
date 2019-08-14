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
      tab :users do
        columns do
          column do
            panel 'New user signups' do
              column_chart User.where('created_at >= ?', 1.week.ago).group_by_month(:created_at, format: '%b').count, ytitle: 'Users'
            end

            panel 'Users signed in' do
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

      tab :practices do
        columns do
          column do
            panel "#{@beginning_of_current_month.strftime('%B %Y')} - current month" do
              table_for Practice.all.sort_by(&:current_month_views).reverse!.each do
                column(:name) {|practice| link_to(practice.name, admin_practice_path(practice))}
                column(:committed_user_count) { |practice| practice.committed_user_count_by_range(@beginning_of_current_month, @end_of_current_month) }
                column('Current month views') {|practice| practice.current_month_views}
              end
            end

            panel "#{@beginning_of_last_month.strftime('%B %Y')} - last month" do
              table_for Practice.all.sort_by(&:last_month_views).reverse!.each do
                column(:name) {|practice| link_to(practice.name, admin_practice_path(practice))}
                column(:committed_user_count) { |practice| practice.committed_user_count_by_range(@beginning_of_last_month, @end_of_last_month) }
                column('Last month views') {|practice| practice.last_month_views}
              end
            end

            panel "#{@beginning_of_two_months_ago.strftime('%B %Y')} - 2 months ago" do
              table_for Practice.all.sort_by(&:two_months_ago_views).reverse!.each do
                column(:name) {|practice| link_to(practice.name, admin_practice_path(practice))}
                column(:committed_user_count) { |practice| practice.committed_user_count_by_range(@beginning_of_two_months_ago, @end_of_two_months_ago) }
                column('2 months ago views') {|practice| practice.two_months_ago_views}
              end
            end

            panel "#{@beginning_of_three_months_ago.strftime('%B %Y')} - 3 months ago" do
              table_for Practice.all.sort_by(&:three_months_ago_views).reverse!.each do
                column(:name) {|practice| link_to(practice.name, admin_practice_path(practice))}
                column(:committed_user_count) { |practice| practice.committed_user_count_by_range(@beginning_of_three_months_ago, @end_of_three_months_ago) }
                column('3 months ago views') {|practice| practice.three_months_ago_views}
              end
            end

            panel 'Lifetime Practice Statistics' do
              table_for Practice.all.sort_by(&:views).reverse!.each do
                column(:name) {|practice| link_to(practice.name, admin_practice_path(practice))}
                column :committed_user_count
                column :number_of_adopted_facilities
                column('Total practice views') {|practice| practice.views}
              end
            end
          end # column
        end # columns
      end # tab

      tab :'Practice search terms' do
        panel "#{@beginning_of_current_month.strftime('%B %Y')} - current month" do
          columns do
            month_current_search_terms = Ahoy::Event
                                              .where(name: 'Practice search', time: @beginning_of_current_month..@end_of_current_month)
                                              .where("properties->>'search_term' is not null")
                                              .group("properties->>'search_term'")
                                              .order('count_all desc').limit(10).count
            _month_current_search_terms = month_current_search_terms.to_a
            column do
              table_for _month_current_search_terms do
                column('Term') {|st| st[0]}
                column('Count') {|st| st[1]}
              end
            end
            column do
              pie_chart(month_current_search_terms)
            end
          end
        end

        panel "#{@beginning_of_last_month.strftime('%B %Y')} - last month" do
          columns do
            month_last_search_terms = Ahoy::Event
                                           .where(name: 'Practice search', time: @beginning_of_last_month..@end_of_last_month)
                                           .group("properties->>'search_term'")
                                           .order('count_all desc').count
            _month_last_search_terms = month_last_search_terms.to_a
            column do
              table_for _month_last_search_terms do
                column('Term') {|st| st[0]}
                column('Count') {|st| st[1]}
              end
            end
            column do
              pie_chart(month_last_search_terms)
            end
          end
        end

        panel "#{@beginning_of_two_months_ago.strftime('%B %Y')} - 2 months ago" do
          columns do
            month_2_search_terms = Ahoy::Event
                                        .where(name: 'Practice search', time: @beginning_of_two_months_ago..@end_of_two_months_ago)
                                        .group("properties->>'search_term'")
                                        .order('count_all desc').count
            _month_2_search_terms = month_2_search_terms.to_a
            column do
              table_for _month_2_search_terms do
                column('Term') {|st| st[0]}
                column('Count') {|st| st[1]}
              end
            end
            column do
              pie_chart(month_2_search_terms)
            end
          end
        end

        panel "#{@beginning_of_three_months_ago.strftime('%B %Y')} - 3 months ago" do
          columns do
            month_3_search_terms = Ahoy::Event
                                        .where(name: 'Practice search', time: @beginning_of_three_months_ago..@end_of_three_months_ago)
                                        .group("properties->>'search_term'")
                                        .order('count_all desc').count
            _month_3_search_terms = month_3_search_terms.to_a
            column do
              table_for _month_3_search_terms do
                column('Term') {|st| st[0]}
                column('Count') {|st| st[1]}
              end
            end
            column do
              pie_chart(month_3_search_terms)
            end
          end
        end # panel
      end # tab
    end # tabs
  end # content
end # register_page

