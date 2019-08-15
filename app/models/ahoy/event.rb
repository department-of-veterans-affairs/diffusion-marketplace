class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true

  store_accessor :properties, :search_term

  def self.count_for_range(start_date, end_date, property_value)
    where(name: 'Practice search', time: start_date..end_date)
      .where("properties->>'search_term' = ?", property_value)
      .count
  end
end
