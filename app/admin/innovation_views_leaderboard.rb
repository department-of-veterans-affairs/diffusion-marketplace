include ActiveAdminHelpers

ActiveAdmin.register_page 'Innovation Views Leaderboard' do
  menu label: proc {I18n.t('active_admin.innovation_views_leaderboard')}

  controller do
    helper_method :set_date_values
    before_action :set_leaderboard_values

    def set_leaderboard_values
      set_date_values
      @published_enabled_approved_practices = Practice.cached_published_enabled_approved_practices
      @practices_sorted_by_most_views_this_month = @published_enabled_approved_practices.sort_by(&:current_month_views).reverse!.pluck(:id, :name)

      @practice_views_for_current_month_with_names = Ahoy::Event.practice_views_for_multiple_practices_by_date_range(
        @published_enabled_approved_practices.ids, @beginning_of_current_month, @end_of_current_month
      ).group(:properties).count.sort_by { |key, value| value }.reverse!.each { |views_array| views_array << Practice.find_by(id: views_array.first.first).name }

      @total_practice_views_for_last_month = Ahoy::Event.practice_views_for_multiple_practices_by_date_range(
        @published_enabled_approved_practices.ids, @beginning_of_last_month, @end_of_last_month
      ).group(:properties).count.sort_by { |key, value| value }.reverse!.collect! { |views_array| views_array.last }.sum

      @total_practice_views_for_two_months_ago = Ahoy::Event.practice_views_for_multiple_practices_by_date_range(
        @published_enabled_approved_practices.ids, @beginning_of_two_months_ago, @end_of_two_months_ago
      ).group(:properties).count.sort_by { |key, value| value }.reverse!.collect! { |views_array| views_array.last }.sum

      @total_practice_views_for_three_months_ago = Ahoy::Event.practice_views_for_multiple_practices_by_date_range(
        @published_enabled_approved_practices.ids, @beginning_of_three_months_ago, @end_of_three_months_ago
      ).group(:properties).count.sort_by { |key, value| value }.reverse!.collect! { |views_array| views_array.last }.sum

      @total_practice_views_all_time = Ahoy::Event.practice_views_for_multiple_practices(
        @published_enabled_approved_practices.ids
      ).group(:properties).count.sort_by { |key, value| value }.reverse!.each { |views_array| views_array << Practice.find_by(id: views_array.first.first).name }

      @total_current_month_views = @practice_views_for_current_month_with_names.collect! { |practice_views_array| practice_views_array.second }.sum
      @total_lifetime_views = @total_practice_views_all_time.collect! { |practice_views_array| practice_views_array.second }.sum

      @practices_hash_sorted_by_most_views_this_month = []
      @practices_sorted_by_most_views_this_month.each do |practice|
        @practices_hash_sorted_by_most_views_this_month << {
          practice: [practice.first, practice.last],
          current_month: Ahoy::Event.practice_views_for_single_practice_by_date_range(
            practice.first, @beginning_of_current_month, @end_of_current_month
          ).count,
          last_month: Ahoy::Event.practice_views_for_single_practice_by_date_range(
            practice.first, @beginning_of_last_month, @end_of_last_month
          ).count,
          two_months_ago: Ahoy::Event.practice_views_for_single_practice_by_date_range(
            practice.first, @beginning_of_two_months_ago, @end_of_two_months_ago
          ).count,
          three_months_ago: Ahoy::Event.practice_views_for_single_practice_by_date_range(
            practice.first, @beginning_of_three_months_ago, @end_of_three_months_ago
          ).count,
          all_time: Ahoy::Event.practice_views_for_single_practice(practice.first).count
        }
      end
    end
  end

  content title: proc {I18n.t("active_admin.innovation_views_leaderboard")} do
    columns do
      column do
        panel('Innovation Views Leaderboard', class: 'dm-panel-container', id: 'dm-practice-views-leaderboard') do
          table_for practices_hash_sorted_by_most_views_this_month, id: 'practice-views-table' do
            column(:name) { |pr_hash| link_to(pr_hash[:practice].last, admin_practice_path(pr_hash[:practice].first)) }
            column("#{date_headers[:current]}") { |pr_hash| pr_hash[:current_month] }
            column("#{date_headers[:one_month_ago]}") { |pr_hash| pr_hash[:last_month] }
            column("#{date_headers[:two_month_ago]}") { |pr_hash| pr_hash[:two_months_ago] }
            column("#{date_headers[:three_month_ago]}") { |pr_hash| pr_hash[:three_months_ago] }
            column("Total lifetime views") { |pr_hash| pr_hash[:all_time] }
          end

          script do
            raw "$(document).ready(function($) {
                        $('#practice-views-table').append('<tr><td><b>Totals</b></td><td><b>#{total_current_month_views}</b></td><td><b>#{total_practice_views_for_last_month}</b></td><td><b>#{total_practice_views_for_two_months_ago}</b></td><td><b>#{total_practice_views_for_three_months_ago}</b></td><td><b>#{total_lifetime_views}</b></td></tr>');
                      });
                    "
          end
        end
      end # column
    end # columns
  end # content
end