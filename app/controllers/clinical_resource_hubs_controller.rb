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

  # GET /crh/:id/created_practices
  def created_chr_practices
    debugger
    page = 1
    page = params[:page].to_i if params[:page].present?
    sort_option = params[:sort_option] || 'a_to_z'
    search_term = params[:search_term] ? params[:search_term].downcase : nil
    categories = params[:categories] || nil
    created_practices = helpers.is_user_a_guest? ? Practice.get_facility_created_practices(@va_facility.id, search_term, sort_option, categories, true) : Practice.get_facility_created_practices(@va_facility.id, search_term, sort_option, categories, false)

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
      format.html
      format.json { render :json => { practice_cards_html: practice_cards_html, count: created_practices.size, next: @pagy_created_info.next } }
    end
  end




  private
  def set_crh
    @visn = params[:id].present? ? Visn.find_by!(number: params[:id]) : Visn.find_by!(number: params[:number])
    @crh = ClinicalResourceHub.find_by!(visn: @visn) if @visn.present?
  end
end