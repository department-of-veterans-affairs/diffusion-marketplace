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
    sql = "SELECT p.id, p.name, p.summary, p.slug, dh.facility_id, dhs.status, dhs.start_time,
          (select count(*) from diffusion_histories where p.id = diffusion_histories.practice_id) adoptions
          FROM practices p
          JOIN diffusion_histories dh on p.id = dh.practice_id
          JOIN diffusion_history_statuses dhs on dh.id = dhs.diffusion_history_id
          WHERE p.published = $1 AND dh.facility_id = $2 order by adoptions desc"
    ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, true], [nil, "#{station_number}"]]).to_a
  end

  def self.get_adoptions_by_facility_and_category(station_number, category_id)
    sql = "SELECT distinct p.id, p.name, p.summary, p.slug, dh.facility_id, dhs.status, dhs.start_time,
          (select count(*) from diffusion_histories where p.id = diffusion_histories.practice_id) adoptions
          FROM practices p
          JOIN diffusion_histories dh on p.id = dh.practice_id
          JOIN diffusion_history_statuses dhs on dh.id = dhs.diffusion_history_id
          JOIN category_practices cp on p.id = cp.practice_id
          JOIN categories c on cp.category_id = c.id
          WHERE p.published = $3 AND p.enabled = $3 AND p.approved = $3 AND dh.facility_id = $1 AND c.id = $2 order by adoptions desc"
    ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{station_number}"], [nil, "#{category_id}"], [nil, true]]).to_a
  end

  def self.get_adoptions_by_facility_and_keyword(station_number, key_word)
    search_term = key_word
    key_word = "%" + key_word.downcase + "%"
    maturity_level = get_maturity_level(search_term)
    sql = "SELECT distinct p.id, p.name, p.summary, p.slug, dh.facility_id, dhs.status, dhs.start_time,
          (select count(*) from diffusion_histories where p.id = diffusion_histories.practice_id) adoptions
          FROM practices p
          JOIN diffusion_histories dh on p.id = dh.practice_id
          JOIN diffusion_history_statuses dhs on dh.id = dhs.diffusion_history_id
          JOIN category_practices cp on p.id = cp.practice_id
          JOIN categories c on cp.category_id = c.id
          JOIN va_facilities vaf on dh.facility_id = vaf.station_number
          WHERE p.published = $4 AND p.enabled = $4 AND p.approved = $4 AND dh.facility_id = $1
          AND (p.name ilike ($2) OR p.description ilike ($2) OR p.short_name ilike ($2) OR p.summary ilike ($2) OR p.tagline ilike ($2)
          OR p.overview_problem ilike ($2) OR p.overview_solution ilike ($2) OR p.overview_results ilike ($2) OR p.maturity_level = ($3) "
    sql += "OR $5 ilike any(c.related_terms) "
    sql += "OR c.name ilike ($2) OR vaf.official_station_name ilike ($2) "
    sql += "OR vaf.common_name ilike ($2)) order by adoptions desc"
    ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{station_number}"], [nil, "#{key_word}"], [nil, maturity_level], [nil, true], [nil, search_term]]).to_a
  end

  def self.get_adoptions_by_facility_category_and_keyword(station_number, category_id, key_word)
    search_term = key_word
    key_word = "%" + key_word.downcase + "%"
    maturity_level = get_maturity_level(search_term)
    sql = "SELECT distinct p.id, p.name, p.summary, p.slug, dh.facility_id, dhs.status, dhs.start_time,
          (select count(*) from diffusion_histories where p.id = diffusion_histories.practice_id) adoptions
          FROM practices p
          JOIN diffusion_histories dh on p.id = dh.practice_id
          JOIN diffusion_history_statuses dhs on dh.id = dhs.diffusion_history_id
          JOIN category_practices cp on p.id = cp.practice_id
          JOIN categories c on cp.category_id = c.id
          JOIN va_facilities vaf on dh.facility_id = vaf.station_number
          WHERE p.published = $5 AND p.enabled = $5 AND p.approved = $5 AND dh.facility_id = $1 AND c.id = $2
          AND (p.name ilike ($3) OR p.description ilike ($3) OR p.short_name ilike ($3) OR p.summary ilike ($3) OR p.tagline ilike ($3)
          OR p.overview_problem ilike ($3) OR p.overview_solution ilike ($3) OR p.overview_results ilike ($3) OR p.maturity_level = ($4) "
        sql += "OR $6 ilike any(c.related_terms) "
        sql += "OR c.name ilike ($3) OR vaf.official_station_name ilike ($3) "
        sql += "OR vaf.common_name ilike ($3)) order by adoptions desc"
    ActiveRecord::Base.connection.exec_query(sql, "SQL", [[nil, "#{station_number}"], [nil, "#{category_id}"], [nil, "#{key_word}"], [nil, maturity_level], [nil, true], [nil, search_term]]).to_a
  end

  def self.get_maturity_level(search_term)
    maturity_level = 99
    search_term = search_term.downcase
    if search_term.include?("emerging")
      maturity_level = 0
    elsif search_term.include?("replicate")
      maturity_level = 1
    elsif search_term.include?("scale")
      maturity_level = 2
    end
    maturity_level
  end

  def self.rewrite_practices_adopted_at_this_facility_filtered_by_category(adoptions_at_facility, total_adoptions_for_practice)
    ret_val = ""
    if adoptions_at_facility.count > 0
      adoptions_at_facility.each do |ad|
        start_date = ad["start_time"].to_date.strftime("%m/%d/%Y")
        ret_val += '<tr>'
        ret_val += '<th scope="row" role="rowheader">'
        ret_val += '<a class="dm-internal-link" href="/practices/' + ad["slug"] + '"> ' + ad["name"] + '</a>'



        #<a class="dm-internal-link" href="<%= practice_path(ad["slug"]) %>"><%=ad["name"]%></a>

        # if @current_user


        # ret_val += '<a href="<%= practice_favorite_path(' + ad["id"].to_s + ', format: :js) %>" data-method="post" data-remote="true" rel="nofollow" aria-label="Bookmark <%= @practice.name %>" tabindex="-1" aria-hidden="true" class="dm-favorite-practice-link dm-icon-link text-no-underline font-sans-xs text-primary desktop:grid-col-3 grid-col-6 desktop:margin-bottom-0 margin-bottom-2">'
        # ret_val += '<i class="<%= current_user.favorite_practice_ids.include?(' + ad["id"].to_s + ' ? "fas" : "far" %> fa-bookmark dm-favorite-icon-<%= @practice.id %>  margin-right-05"></i>'
        # ret_val += '</a>'

        # <a href="<%= practice_favorite_path(@practice, format: :js) %>" data-method="post" data-remote="true" rel="nofollow" aria-label="Bookmark <%= @practice.name %>" tabindex="-1" aria-hidden="true" class="dm-favorite-practice-link dm-icon-link text-no-underline font-sans-xs text-primary desktop:grid-col-3 grid-col-6 desktop:margin-bottom-0 margin-bottom-2">
        # <i class="<%= current_user.favorite_practice_ids.include?(@practice.id) ? 'fas' : 'far '%> fa-bookmark dm-favorite-icon-<%= @practice.id %>  margin-right-05"></i>
        #   <span class="dm-favorite-practice-link-text">
        #     <%= current_user.favorite_practice_ids.include?(@practice.id) ? 'Bookmarked' : 'Bookmark' %>
        #   </span>
        # </a>

        ret_val += '<br />' + ad["summary"] + '</th>'
        ret_val += '<td data-sort-value='  + ad["status"] + '>' + ad["status"] + '</td>'
        ret_val += '<td data-sort-value='  + start_date + '>' + start_date + '</td>'
        ret_val += '<td data-sort-value='  + ad["adoptions"].to_s + '>' + ad["adoptions"].to_s + '</td>'
        ret_val += '</tr>'
      end
    end
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

