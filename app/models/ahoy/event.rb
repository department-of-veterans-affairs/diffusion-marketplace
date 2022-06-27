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
  scope :by_date_range, -> (start_date, end_date) { where(time: start_date..end_date) }
  scope :site_visits_by_date_range, -> (start_date, end_date) {
    site_visits_excluding_null_ips_and_duplicates.by_date_range(start_date, end_date).group("properties->>'ip_address'")
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
  scope :practice_emails_by_practice, -> (practice_id) { practice_emails.where("properties->>'practice_id' = '#{practice_id}'") }
  scope :practice_show_views, -> { where(name: 'Practice show') }
  scope :views_for_single_practice, -> (practice_id) { practice_show_views.where_props(practice_id: practice_id) }
  scope :views_by_date_range_for_single_practice, -> (practice_id, start_date, end_date) {
    practice_show_views.where_props(practice_id: practice_id).exclude_duplicates.by_date_range(start_date, end_date)
  }
  scope :views_for_multiple_practices, -> (practice_ids) {
    practice_show_views.where("properties->>'practice_id' IN ('#{practice_ids.join("', '")}')")
  }
  scope :views_by_date_range_for_multiple_practices, -> (practice_ids, start_date, end_date) {
    practice_show_views.where(
      "properties->>'practice_id' IN ('#{practice_ids.join("', '")}')"
    ).by_date_range(start_date, end_date)
  }


  store_accessor :properties, :search_term

  def self.count_for_range(ahoy_event_name, start_date, end_date, property_value)
    where(name: ahoy_event_name, time: start_date..end_date)
      .where("properties->>'search_term' = ?", property_value)
      .count
  end

  def self.total_search_term_counts_for_range(start_date, end_date)
    search_term_not_null = "properties->>'search_term' is not null"

    where(
      name: 'Practice search',
      time: start_date..end_date
    ).where(search_term_not_null).or(
      where(
        name: 'VISN practice search',
        time: start_date..end_date
      ).where(search_term_not_null)).or(
      where(
        name: 'Facility practice search',
        time: start_date..end_date
      ).where(search_term_not_null)).count
  end
end
