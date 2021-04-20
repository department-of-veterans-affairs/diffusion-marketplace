class VaFacility < ApplicationRecord
  extend FriendlyId
  friendly_id :common_name, use: :slugged

  belongs_to :visn

  def self.get_total_adoptions_for_each_practice(va_facilities)
    total_adoptions = []
    va_facilities.each do |f|
      total_adoptions << DiffusionHistory.where(practice_id: f["id"]).count
    end
    total_adoptions
  end

  def self.get_adoptions_by_facility(station_number)
    sql = "SELECT p.id, p.name, dh.facility_id, dhs.status, dhs.start_time,
          (select count(*) from diffusion_histories where p.id = diffusion_histories.practice_id) adoptions
          FROM practices p
          JOIN diffusion_histories dh on p.id = dh.practice_id
          JOIN diffusion_history_statuses dhs on dh.id = dhs.diffusion_history_id
          WHERE p.published = true AND dh.facility_id = $1 order by adoptions desc"
    ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{station_number}"]]).to_a
  end

  def self.get_adoptions_by_facility_and_category(station_number, category_id)
    sql = "SELECT p.id, p.name, dh.facility_id, dhs.status, dhs.start_time,
          (select count(*) from diffusion_histories where p.id = diffusion_histories.practice_id) adoptions
          FROM practices p
          JOIN diffusion_histories dh on p.id = dh.practice_id
          JOIN diffusion_history_statuses dhs on dh.id = dhs.diffusion_history_id
          JOIN category_practices cp on p.id = cp.practice_id
          JOIN categories c on cp.category_id = c.id
          WHERE p.published = true AND dh.facility_id = $1 AND c.id = $2 order by adoptions desc"
    ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{station_number}"], [nil, "#{category_id}"]]).to_a
  end

  def self.get_adoptions_by_facility_and_keyword(station_number, key_word)
    key_word = "%" + key_word.downcase + "%"
    sql = "SELECT p.id, p.name, dh.facility_id, dhs.status, dhs.start_time,
          (select count(*) from diffusion_histories where p.id = diffusion_histories.practice_id) adoptions
          FROM practices p
          JOIN diffusion_histories dh on p.id = dh.practice_id
          JOIN diffusion_history_statuses dhs on dh.id = dhs.diffusion_history_id
          WHERE p.published = true AND dh.facility_id = $1
          AND (p.name ilike ($2) OR p.description ilike ($2) OR p.short_name ilike ($2))
          order by adoptions desc"
    ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{station_number}"], [nil, "#{key_word}"]]).to_a
  end

  def self.get_adoptions_by_facility_category_and_keyword(station_number, category_id, key_word)
    key_word = "%" + key_word.downcase + "%"
    sql = "SELECT p.id, p.name, dh.facility_id, dhs.status, dhs.start_time,
          (select count(*) from diffusion_histories where p.id = diffusion_histories.practice_id) adoptions
          FROM practices p
          JOIN diffusion_histories dh on p.id = dh.practice_id
          JOIN diffusion_history_statuses dhs on dh.id = dhs.diffusion_history_id
          JOIN category_practices cp on p.id = cp.practice_id
          JOIN categories c on cp.category_id = c.id
          WHERE p.published = true AND dh.facility_id = $1 AND c.id = $2
          AND (p.name ilike ($3) OR p.description ilike ($3) OR p.short_name ilike ($3))
          order by adoptions desc"
    ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{station_number}"], [nil, "#{category_id}"], [nil, "#{key_word}"],]).to_a
  end



  def self.rewrite_practices_adopted_at_this_facility_filtered_by_category(adoptions_at_facility, total_adoptions_for_practice)
    # ret_val = "<div id='va_facility_adoption_results' class='grid-col-12 usa-table-container--scrollable'>"
    ret_val = '<table class="usa-table grid-col-12">'
    ret_val += '<caption></caption>'
    ret_val += '<thead>'
    ret_val += "<th data-sortable scope='col' role='columnheader' aria-sort='descending'>Practice name</th>"
    ret_val += "<th data-sortable scope='col' role='columnheader'>Status "
    ret_val += '<a href="#facility_status_def" aria-controls="facility_status_def" data-open-modal><span><img class="fake-link_2" id="facility-status-modal" src="/assets/question_tooltip.svg"/></span></a></th>'
    ret_val += "<th data-sortable scope='col' role='columnheader'>Start date</th>"
    ret_val += "<th data-sortable scope='col' role='columnheader'>Total VA adoptions</th></thead><tbody>"
    if adoptions_at_facility.count > 0
        adoptions_at_facility.each do |ad|
          ret_val += "<tr>"
          ret_val += "<th scope='row' role='rowheader'>" + ad["name"] + "</th>"
          ret_val += "<td data-sort-value=" + ad["status"] +  ">" + ad["status"] + "</td>"
          ret_val += "<td data-sort-value=" + ad["start_time"].to_s +  ">" + ad["start_time"].to_s + "</td>"
          ret_val += "<td data-sort-value=" + ad["adoptions"].to_s +  ">" + ad["adoptions"].to_s + "</td>"
          ret_val += "</tr>"
        end
    end
    ret_val += "</tbody></table>"
    ret_val += "<div class='usa-sr-only usa-table__announcement-region' aria-live='polite'></div>"
    ret_val
    end


  def self.get_all_facilities(order_by = "facility")
    sql = "select va.id, va.visn_id, va.slug, va.station_number, va.common_name, va.official_station_name, va.fy17_parent_station_complexity_level, vi.number as visn_number, street_address_state as state, "
    sql += "(select count(*) from practice_origin_facilities p where p.facility_id = va.station_number) practices_created, "
    sql += "(select count(*) from diffusion_histories d where d.facility_id = va.station_number) adoptions "
    sql += "from va_facilities va join visns vi on va.visn_id = vi.id "
    if order_by == "facility"
      sql += "order by official_station_name;"
    elsif order_by == "common_name"
      sql += "order by common_name;"
    elsif order_by == "visn"
      sql += "order by visn_number;"
    elsif order_by == "type"
      sql += "order by fy17_parent_station_complexity_level;"
    elsif order_by == "created"
      sql += "order by practices_created;"
    elsif order_by == "adoptions"
      sql += "order by adoptions;"
    end
    ActiveRecord::Base.connection.exec_query(sql)
  end

  def self.get_types
    VaFacility.select(:fy17_parent_station_complexity_level).distinct.order(:fy17_parent_station_complexity_level)
  end

  before_save :clear_va_facility_cache_on_save
  after_save :reset_va_facility_cache

  attr_accessor :reset_cached_va_facilities

  def clear_va_facility_cache
    Rails.cache.delete('va_facilities')
  end

  def reset_va_facility_cache
    clear_va_facility_cache if self.reset_cached_va_facilities
  end

  def clear_va_facility_cache_on_save
    if self.changed?
      self.reset_cached_va_facilities = true
    end
  end

  def self.cached_va_facilities
    Rails.cache.fetch('va_facilities') do
      VaFacility.all
    end
  end
end

