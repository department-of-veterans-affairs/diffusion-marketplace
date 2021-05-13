class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true

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
