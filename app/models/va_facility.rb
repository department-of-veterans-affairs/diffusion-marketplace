class VaFacility < ApplicationRecord
  extend FriendlyId
  friendly_id :common_name, use: :slugged

  belongs_to :visn

  def self.get_practices_created_by_facility(station_number)
    sql = "select p.* from practices p join practice_origin_facilities pof on pof.practice_id = p.id where pof.facility_id = '#{station_number}'";
    results =  ActiveRecord::Base.connection.execute(sql)
    fields = results.fields
     results.values.map { |value_set|
      hash = Hash[fields.zip(value_set)]
      model = Practice.new(hash)
      model.instance_variable_set :@new_record, false
      model
     }
  end

  def self.get_adoptions_by_facility(station_number)
    DiffusionHistory.where(facility_id: station_number)
  end

  def self.get_categories
    Category.all.order('name')
  end

  def self.get_all_facilities(order_by = "facility")
    sql = "select va.id, va.visn_id, va.station_number, va.common_name, va.official_station_name, va.fy17_parent_station_complexity_level, vi.number as visn_number, "
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
      #ActiveRecord::Base.connection.execute(sql).to_a
  end

  def self.get_visns
    Visn.all.order('number')
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

