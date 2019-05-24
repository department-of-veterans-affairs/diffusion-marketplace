class ApplicationController < ActionController::Base
  before_action :setup_breadcrumb_navigation

  protected

  def setup_breadcrumb_navigation
    session[:breadcrumbs] = session[:breadcrumbs] || []

    # reset if home page
    if params[:action] == 'index' && params[:controller] == 'home'
      session[:breadcrumbs] = []
      return
    end

    url = URI::parse(request.referer || '')
    # search 'path'
    if params[:action] == 'index' && params[:controller] == 'practices'
      # empty the bread crumbs and start a new path
      session[:breadcrumbs] = []
      session[:breadcrumbs] << {'display': 'Practices', 'path': '/practices'}
    end

    # add the search breadcrumb if there is a search query going to the practice page
    if params[:action] == 'show' && params[:controller] == 'practices' && url.path.include?('search') && (url.query.present? && url.query.include?('query='))
      search_breadcrumb = session[:breadcrumbs].find { |bc| bc['display'] == 'Search' || bc[:display] == 'Search'}
      search_breadcrumb['path'] = "#{url.path}?#{url.query}" if search_breadcrumb.present?
      session[:breadcrumbs] << {'display': 'Search', 'path': "#{url.path}?#{url.query}"} if search_breadcrumb.blank?
    end

    # practice partners path
    if params[:action] == 'index' && params[:controller] == 'practice_partners'
      # empty the bread crumbs and start a new 'path'
      session[:breadcrumbs] = []
      session[:breadcrumbs] << {'display': 'Partners', 'path': practice_partners_path}
    end

    # practice partner show path
    if params[:action] == 'show' && params[:controller] == 'practice_partners'
      # add the practice partner to the crumbs if it's not there already
      @practice_partner = PracticePartner.friendly.find(params[:id])
      unless session[:breadcrumbs].find {|b| b['display'] == @practice_partner.name}.present?
        session[:breadcrumbs] << {'display': @practice_partner.name, 'path': practice_partner_path(@practice_partner)}
      end
    end

  end

  private

  def facilities_json
    JSON.parse(File.read("#{Rails.root}/lib/assets/va_gov_facilities_all_response.json"))
  end

end
