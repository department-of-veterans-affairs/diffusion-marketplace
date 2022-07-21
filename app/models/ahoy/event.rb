class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true

  scope :site_visits, -> { where(name: 'Site visit') }
  # is_duplicate was added to "properties" to remove duplicate 'Site visit' and 'Practice show' counts as a result of turbolinks loading the page twice, triggering two ahoy_event to be saved
  scope :exclude_duplicates, -> { where("properties->>'is_duplicate' is null") }
  scope :exclude_null_ips_and_duplicates, -> {
    where("properties->>'ip_address' is not null").exclude_duplicates
  }
  scope :site_visits_excluding_null_ips_and_duplicates, -> { site_visits.exclude_null_ips_and_duplicates }
  scope :by_date_or_earlier, -> (date) { where('time >= ?', date) }
  scope :by_date_range, -> (start_date, end_date) { where(time: start_date..end_date) }
  scope :site_visits_by_date_range, -> (start_date, end_date) {
    site_visits_excluding_null_ips_and_duplicates.by_date_range(start_date, end_date)
  }
  scope :site_visits_by_unique_users_and_date_or_earlier, -> (date) {
    site_visits_excluding_null_ips_and_duplicates.where.not(user_id: nil).by_date_or_earlier(date)
  }
  scope :custom_page_visits, -> (page) {
    site_visits_excluding_null_ips_and_duplicates.where(
      "properties->>'page_group' = '#{page[:group]}'"
    ).where(
      "properties->>#{page[:slug] === 'home' ? "'page_slug' is null" : "'page_slug' = '#{page[:slug]}'" }"
    )
  }
  scope :custom_page_visits_by_date_range, -> (page, start_date, end_date) {
    custom_page_visits(page).by_date_range(start_date, end_date).group("properties->>'ip_address'")
  }
  scope :practice_emails, -> { where(name: 'Practice email') }
  scope :exclude_null_practice_id, -> { where("properties->>'practice_id' is not null") }
  scope :practice_emails_excluding_null_practice_id, -> { practice_emails.exclude_null_practice_id }
  scope :practice_emails_for_practice, -> (practice_id) { practice_emails.where("properties->>'practice_id' = '#{practice_id}'") }
  scope :practice_emails_for_practice_by_date_range, -> (practice_id, start_date, end_date) {
    practice_emails_for_practice(practice_id).by_date_range(start_date, end_date)
  }
  scope :practice_views, -> { where(name: 'Practice show').exclude_duplicates }
  scope :practice_views_for_single_practice, -> (practice_id) { practice_views.where_props(practice_id: practice_id) }
  scope :practice_views_for_single_practice_by_date_range, -> (practice_id, start_date, end_date) {
    practice_views.where_props(practice_id: practice_id).by_date_range(start_date, end_date)
  }
  scope :practice_views_for_multiple_practices, -> (practice_ids) {
    practice_views.where("properties->>'practice_id' IN ('#{practice_ids.join("', '")}')")
  }
  scope :practice_views_for_multiple_practices_by_date_range, -> (practice_ids, start_date, end_date) {
    practice_views.where(
      "properties->>'practice_id' IN ('#{practice_ids.join("', '")}')"
    ).by_date_range(start_date, end_date)
  }
  scope :exclude_null_search_term, -> { where("properties->>'search_term' is not null") }
  scope :search_terms_on_main_search_page, -> { where(name: 'Practice search') }
  scope :search_terms_on_visn_page, -> { where(name: 'VISN practice search') }
  scope :search_terms_on_facility_page, -> { where(name: 'Facility practice search') }
  # uncomment the line below in when we add CRH data to the admin panel (6/30/22)
  # scope :search_terms_on_facility_page, -> { where(name: 'CRH practice search') }
  # refactor the line below to include CRH search terms when we add CRH data to the admin panel (6/30/22)
  scope :all_search_terms, -> {
    exclude_null_search_term.search_terms_on_main_search_page.or(search_terms_on_visn_page).or(search_terms_on_facility_page)
  }
  scope :all_search_terms_by_date_range, -> (start_date, end_date) {
    all_search_terms.by_date_range(start_date, end_date)
  }
  scope :search_term_by_page_and_term, -> (page_search, term) {
    where(name: page_search).where("properties->>'search_term' = ?", term)
  }
  scope :search_term_by_page_and_term_and_date_range, -> (page_search, term, start_date, end_date) {
    where(name: page_search).where("properties->>'search_term' = ?", term).by_date_range(start_date, end_date)
  }

  store_accessor :properties, :search_term
end
