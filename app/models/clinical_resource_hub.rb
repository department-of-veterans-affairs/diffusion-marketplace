class ClinicalResourceHub < ApplicationRecord
  belongs_to :visn
  has_many :diffusion_histories, dependent: :destroy
  has_many :practice_origin_facilities, dependent: :destroy
  has_many :practices_through_diffusion, through: :diffusion_histories, source: :practice
  has_many :practices, through: :practice_origin_facilities

  after_commit :clear_caches

  scope :sort_by_visn_number, -> { includes(:visn).sort_by { |crh| crh.visn.number } }

  def to_param
    visn.number.to_s
  end

  def self.cached_clinical_resource_hubs
    Rails.cache.fetch('clinical_resource_hubs') do
      ClinicalResourceHub.all
    end
  end

  def get_crh_adopted_practices( crh_id, options = { is_user_guest: true })
    options[:is_user_guest] ? Practice.public_facing.load_associations.get_by_adopted_crh(crh_id) :
        Practice.published_enabled_approved.load_associations.get_by_adopted_crh(crh_id)
  end

  def get_crh_created_practices(crh_id, options = { is_user_guest: true })
    options[:is_user_guest] ? Practice.public_facing.load_associations.get_by_created_crh(crh_id) :
        Practice.published_enabled_approved.load_associations.get_by_created_crh(crh_id)
  end

  private

  def clear_caches
    (practices + practices_through_diffusion).uniq.each(&:clear_searchable_cache)
    Rails.cache.delete('clinical_resource_hubs')
  end
end
