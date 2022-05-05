module VaFacilitiesHelper
  def created_practices_count(id)
    is_user_a_guest? ? Practice.public_facing.get_by_created_facility(id).size : Practice.published_enabled_approved.get_by_created_facility(id).size
  end
  def adopted_practices_count(id)
    is_user_a_guest? ? Practice.public_facing.get_by_adopted_facility(id).size : Practice.published_enabled_approved.get_by_adopted_facility(id).size
  end
end