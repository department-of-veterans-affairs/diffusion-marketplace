class ClinicalResourceHubsController < ApplicationController
  include PracticesHelper
  include PracticeUtils
  before_action :set_crh, only: [:show, :created_crh_practices]
  def show
    @visn_va_facilities = VaFacility.get_by_visn(@visn).get_relevant_attributes
    @visn_crh = ClinicalResourceHub.cached_clinical_resource_hubs.find_by(visn: @visn)

    @practices_created_by_crh = @crh.get_crh_created_practices(@crh.id, is_user_guest: helpers.is_user_a_guest?)
    @practices_created_json = practices_json(@practices_created_by_crh) unless @practices_created_by_crh == nil

    @practices_adopted_by_crh = @crh.get_crh_adopted_practices(@crh.id,  is_user_guest: helpers.is_user_a_guest?)

    @practices_adopted_json = practices_json(@practices_adopted_by_crh) unless @practices_adopted_by_crh == nil

    @crh_practices_created_categories = []
    get_categories_by_practices(@practices_created_by_crh, @crh_practices_created_categories)

    @crh_practices_adopted_categories = []
    get_categories_by_practices(@practices_adopted_by_crh, @crh_practices_adopted_categories)
  end

  private
  def set_crh
    @visn = params[:id].present? ? Visn.find_by!(number: params[:id]) : Visn.find_by!(number: params[:number])
    @crh = ClinicalResourceHub.find_by!(visn: @visn) if @visn.present?
  end
end