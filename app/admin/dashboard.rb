ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel 'New user signups' do
          column_chart User.where('created_at >= ?', 1.week.ago).group_by_day(:created_at, format: '%b %e').count, ytitle: 'Users'
        end
      end # column

      column do
        panel 'Most recent users' do
          table_for User.order('id desc').limit(10).each do |_user|
            column(:email)    { |user| link_to(user.email, admin_user_path(user)) }
            column :first_name
            column :last_name
            column :visn
            column :created_at
          end
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
                },{
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

        panel 'Google analytics' do
          if Rails.env.production?
            link_to 'Click here', 'https://analytics.google.com/analytics/web/?authuser=0#/report-home/a139930129w201651154p195616875', target: '_blank'
          else
            link_to 'Click here', 'https://analytics.google.com/analytics/web/?authuser=0#/report-home/a139930129w200808714p194961951', target: '_blank'
          end
        end
      end # column
      column do
        panel 'Practice statistics' do
          table_for Practice.all.each do |_practice|
            column(:name)    { |practice| link_to(practice.name, admin_practice_path(practice)) }
            column :comitted_user_count
            column :number_of_adopted_facilities
          end
        end
      end # column
    end # columns
  end # content
end

