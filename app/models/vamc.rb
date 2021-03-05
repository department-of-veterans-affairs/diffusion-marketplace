class Vamc < ApplicationRecord

  extend FriendlyId
  friendly_id :common_name, use: :slugged

  belongs_to :visn

  def self.get_all_vamcs
    sql = "select va.id, va.visn_id, va.station_number, va.common_name, va.official_station_name, va.fy17_parent_station_complexity_level, vi.number as visn_number, "
    sql += "(select count(*) from practice_origin_facilities p where p.facility_id = va.station_number) practices_created, "
    sql += "(select count(*) from diffusion_histories d where d.facility_id = va.station_number) adoptions "
    sql += "from vamcs va join visns vi on va.visn_id = vi.id order by va.common_name;"
    ActiveRecord::Base.connection.execute(sql).to_a
  end

  def self.get_visns
    Visn.all.order('number')
  end

  def self.get_types
    Vamc.select(:fy17_parent_station_complexity_level).distinct.order(:fy17_parent_station_complexity_level)
  end
end
