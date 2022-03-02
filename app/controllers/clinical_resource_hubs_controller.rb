class ClinicalResourceHubsController < ApplicationController
  include PracticesHelper
  include PracticeUtils
  include StatesHelper
  before_action :set_crh, only: [:show]
  def show
    visn_id = @visn.id
    visn_number = @visn.number
    @states_str = get_visn_associated_states_str(visn_id)
    @practices_created_categories = []
    get_categories_by_practices(@crh.practices_created_by_crh, @practices_created_categories)
  end

  private
  def set_crh
    @visn = params[:id].present? ? Visn.find_by!(number: params[:id]) : Visn.find_by!(number: params[:number])
    @crh = ClinicalResourceHub.find_by!(visn: @visn) if @visn.present?
  end
end