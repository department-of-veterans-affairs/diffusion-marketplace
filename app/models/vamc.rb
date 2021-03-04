class Vamc < ApplicationRecord

  extend FriendlyId
  friendly_id :common_name, use: :slugged

  belongs_to :visn

  def self.get_all_vamcs
    Vamc.all.order('common_name')
  end

  def self.get_visns
    Visn.all.order('number')
  end

  def self.get_types
    Vamc.select(:fy17_parent_station_complexity_level).distinct.order(:fy17_parent_station_complexity_level)
  end
end
