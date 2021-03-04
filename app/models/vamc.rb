class Vamc < ApplicationRecord

  extend FriendlyId
  friendly_id :common_name, use: :slugged

  belongs_to :visn

  def self.get_all_vamcs
    all_vamcs = Vamc.all.order('common_name')

      #all_vamcs.order('official_station_name')
  end
end
