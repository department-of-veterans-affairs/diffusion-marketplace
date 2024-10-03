include ActiveAdminHelpers

ActiveAdmin.register_page 'Innovation Search Terms' do
  menu false
  # menu label: proc {I18n.t('active_admin.innovation_search_terms')}

  controller do
    helper_method :set_date_values
    before_action :set_search_values

    def set_search_values
      set_date_values

      @all_search_count_totals_by_date_range = [
        {
          current_month_count: Ahoy::Event.all_search_terms.by_date_range(@beginning_of_current_month, @end_of_current_month).count,
          last_month_count: Ahoy::Event.all_search_terms.by_date_range(@beginning_of_last_month, @end_of_last_month).count,
          two_months_ago_count: Ahoy::Event.all_search_terms.by_date_range(@beginning_of_two_months_ago, @end_of_two_months_ago).count,
          three_months_ago_count: Ahoy::Event.all_search_terms.by_date_range(@beginning_of_three_months_ago, @end_of_three_months_ago).count,
          total: Ahoy::Event.all_search_terms.count
        }
      ]

      @practice_search_terms = get_search_term_counts_by_type('Practice search')
      @visn_search_terms = get_search_term_counts_by_type('VISN practice search')
      @facility_search_terms = get_search_term_counts_by_type('Facility practice search')
    end
  end

  content title: proc {I18n.t("active_admin.innovation_search_terms")} do
    columns do
      column do
        # create a table for search totals across all three search types
        create_search_count_totals_table(all_search_count_totals_by_date_range)

        h2 do
          "List of innovation search terms for the last three months sorted by the current month's hits"
        end
        # create a table for general searches, VISN searches, and facility searches
        create_search_terms_table_by_type('General search', practice_search_terms, 'general-practice-search-terms-table') if practice_search_terms.count > 0
        create_search_terms_table_by_type('VISN search', visn_search_terms, 'visn-practice-search-terms-table') if visn_search_terms.count > 0
        create_search_terms_table_by_type('Facility search', facility_search_terms, 'facility-practice-search-terms-table') if facility_search_terms.count > 0

        script do
          raw "$(document).ready(function(){$('tr').attr('id', '')});"
        end
      end # column
    end # columns
  end # content
end