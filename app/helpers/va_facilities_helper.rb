module VaFacilitiesHelper
  def crh_created_practices_count(visn_id)
    crh = ClinicalResourceHub.find_by(visn_id: visn_id)
    @practices_created_by_crh = crh.get_crh_created_practices(crh.id, is_user_guest: is_user_a_guest?)
    @practices_created_by_crh.count
  end

  def crh_adopted_practices_count(visn_id)
    crh = ClinicalResourceHub.find_by(visn_id: visn_id)
    @practices_adopted_by_crh = crh.get_crh_adopted_practices(crh.id,  is_user_guest: is_user_a_guest?)
    @practices_adopted_by_crh.count
  end
end