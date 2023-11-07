module VaFacilitiesHelper
  def crh_created_practices_count(visn_id)
    crh = ClinicalResourceHub.find_by(visn_id: visn_id)
    crh.get_crh_created_practices(crh.id, is_user_guest: is_user_a_guest?).count
  end

  def crh_adopted_practices_count(visn_id)
    crh = ClinicalResourceHub.find_by(visn_id: visn_id)
    crh.get_crh_adopted_practices(crh.id,  is_user_guest: is_user_a_guest?).count
  end
  def created_practices_count(id)
    is_user_a_guest? ? Practice.public_facing.get_by_created_facility(id).size : Practice.published_enabled_approved.get_by_created_facility(id).size
  end
  def adopted_practices_count(id)
    is_user_a_guest? ? Practice.public_facing.get_by_adopted_facility(id).size : Practice.published_enabled_approved.get_by_adopted_facility(id).size
  end
end