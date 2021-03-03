module VisnsHelper
  def get_adopted_practices_count(visn)
    practices = Practice.where(approved: true, published: true, enabled: true)

    visn_vamcs = []
    practices.each do |p|
      Vamc.where(visn: visn).each do |vamc|
        p.diffusion_histories.each do |dh|
          visn_vamcs << dh if dh.facility_id === vamc.station_number
        end
      end
    end
    visn_vamcs.count
  end
end