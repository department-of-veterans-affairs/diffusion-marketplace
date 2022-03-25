class ClinicalResourceHubsController < ApplicationController
  include PracticesHelper
  include PracticeUtils
  include StatesHelper
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

  # GET /crh/:id/created_crh_practices
  def created_crh_practices
    page = 1
    page = params[:page].to_i if params[:page].present?
    sort_option = params[:sort_option] || 'a_to_z'
    search_term = params[:search_term] ? params[:search_term].downcase : nil
    categories = params[:categories] || nil
    created_practices = @crh.get_crh_created_innovations(@crh.id, search_term, sort_option, categories, helpers.is_user_a_guest?)
    @pagy_created_practices = pagy_array(
        created_practices,
        items: 3,
        page: page
    )
    @pagy_created_info = @pagy_created_practices[0]
    practices = @pagy_created_practices[1]
    practice_cards_html = ''
    practices.each do |pr|
      pr_html = render_to_string('shared/_practice_card', layout: false, locals: { practice: pr })
      practice_cards_html += pr_html
    end
    respond_to do |format|
      format.json { render :json => { practice_cards_html: practice_cards_html, count: created_practices.size, next: @pagy_created_info.next } }
    end
  end

  private
  def set_crh
    @visn = params[:id].present? ? Visn.find_by!(number: params[:id]) : Visn.find_by!(number: params[:number])
    @visn_obj = Visn.find_by!(number: params[:number])
    @crh = ClinicalResourceHub.find_by!(visn: @visn) if @visn.present?
  end
end