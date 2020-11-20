module NavigationHelper
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

    def practice_by_id
      Practice.friendly.find(params[:id])
    end

    # This avoids the RecordNotFound error when params[:id] is not present
    def practice_by_practice_id
      Practice.friendly.find(params[:practice_id])
    end

    def empty_breadcrumbs
      session[:breadcrumbs] = []
    end

    def practice_breadcrumb(practice)
      session[:breadcrumbs].find { |b| b['display'] == practice.name }
    end

    def add_practice_breadcrumb(practice)
      session[:breadcrumbs] << { 'display': practice.name, 'path': practice_path(practice) }.stringify_keys
    end

    def add_checklist_breadcrumb(practice)
      session[:breadcrumbs] << { 'display': 'Planning checklist', 'path': practice_planning_checklist_path(practice) }
    end

    def remove_breadcrumb(crumb)
      session[:breadcrumbs].slice!(session[:breadcrumbs].index(crumb))
    end

    def instructions_breadcrumb
      session[:breadcrumbs].find { |b| b['display'] == 'Instructions' }
    end

    def add_instructions_breadcrumb(practice)
      session[:breadcrumbs] << { 'display': 'Edit', 'path': practice_instructions_path(practice) }
    end

    def add_page_builder_homepage_breadcrumb
      session[:breadcrumbs] << { 'display': 'Edit', 'path': practice_instructions_path(practice) }
    end

    def reset_editor_breadcrumbs(practice)
      empty_breadcrumbs
      add_practice_breadcrumb(practice)
      add_instructions_breadcrumb(practice)
    end

    # practice path
    if params[:action] == 'show' && params[:controller] == 'practices'
      if practice_breadcrumb(practice_by_id).blank?
        add_practice_breadcrumb(practice_by_id)
        # If there are any duplicate breadcrumbs, delete them
      elsif practice_breadcrumb(practice_by_id).present? && practice_breadcrumb(practice_by_id).count > 1
        remove_breadcrumb(practice_breadcrumb(practice_by_id))
        add_practice_breadcrumb(practice_by_id)
      end
    end

    # practice checklist path
    if params[:action] == 'planning_checklist' && params[:controller] == 'practices'
      empty_breadcrumbs
      add_practice_breadcrumb(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Planning checklist', 'path': practice_planning_checklist_path(practice_by_practice_id) }
    end

    # practice committed path
    if params[:action] == 'committed' && params[:controller] == 'practices'
      empty_breadcrumbs
      add_practice_breadcrumb(practice_by_practice_id)
      add_checklist_breadcrumb(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Confirmation', 'path': practice_committed_path(practice_by_practice_id) }
    end

    # practice partners path
    if params[:action] == 'index' && params[:controller] == 'practice_partners'
      # empty the bread crumbs and start a new 'path'
      empty_breadcrumbs
      session[:breadcrumbs] << { 'display': 'Partners', 'path': practice_partners_path }
    end

    # practice partner show path
    if params[:action] == 'show' && params[:controller] == 'practice_partners'
      # add the practice partner to the crumbs if it's not there already
      @practice_partner = PracticePartner.friendly.find(params[:id])
      practice = Practice.find_by(slug: session[:user_return_to].split('/').pop) if session[:user_return_to].present?
      partner_breadcrumb = session[:breadcrumbs].find { |b| b['display'] == @practice_partner.name }
      add_partner_breadcrumb = session[:breadcrumbs] << { 'display': @practice_partner.name, 'path': practice_partner_path(@practice_partner) }


      if practice.present? && practice_breadcrumb(practice).blank?
        add_practice_breadcrumb(practice)
      end

      if partner_breadcrumb.blank?
        add_partner_breadcrumb
        # If there are any duplicate practice partner name breadcrumbs, delete them
      elsif partner_breadcrumb.present? && partner_breadcrumb.count > 1
        remove_breadcrumb(partner_breadcrumb)
        add_partner_breadcrumb
      end
    end

    ### PAGE-BUILDER BREADCRUMBS
    def add_landing_page_breadcrumb(path)
      session[:breadcrumbs] << { 'display': "#{@page.page_group.name}", 'path': path }
    end

    def add_sub_page_breadcrumb
      session[:breadcrumbs] << { 'display': "#{@page.title}", 'path': '' }
    end

    if params[:action] == 'show' && params[:controller] == 'page'
      page_slug = params[:page_slug] ? params[:page_slug] : 'home'
      @page = Page.includes(:page_group).find_by(slug: page_slug.downcase, page_groups: {slug: params[:page_group_friendly_id].downcase})

      empty_breadcrumbs
      if page_slug == 'home'
        add_landing_page_breadcrumb("/#{@page.page_group.slug}")
      elsif Page.where(slug: 'home', page_group_id: @page.page_group_id).exists?
        add_landing_page_breadcrumb("/#{@page.page_group.slug}")
        session[:breadcrumbs] << { 'display': "#{@page.title}", 'path': '' }
      else
        add_landing_page_breadcrumb('')
        add_sub_page_breadcrumb
      end
    end

    ### REGISTRATIONS BREADCRUMBS
    def add_profile_breadcrumb
      session[:breadcrumbs] << { 'display': 'Profile', 'path': user_path(current_user) }
    end

    if params[:action] == 'edit' && params[:controller] == 'registrations'
      empty_breadcrumbs
      add_profile_breadcrumb
      session[:breadcrumbs] << { 'display': 'Edit', 'path': '' }
    end

    ### USERS BREADCRUMBS
    if params[:action] == 'show' && params[:controller] == 'users'
      empty_breadcrumbs
      session[:breadcrumbs] << { 'display': 'Profile', 'path': '' }
    end

    if params[:action] == 'edit_profile' && params[:controller] == 'users'
      if current_user.present?
        empty_breadcrumbs
        add_profile_breadcrumb
        session[:breadcrumbs] << { 'display': 'Profile', 'path': '' }
      end
    end

    if params[:action] == 'relevant_to_you' && params[:controller] == 'users'
      empty_breadcrumbs
      session[:breadcrumbs] << { 'display': 'Relevant to you', 'path': '' }
    end

    ### PRACTICE EDITOR BREADCRUMBS ###
    # Instructions breadcrumbs
    if params[:action] == 'instructions' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
    end

    # Introduction breadcrumbs
    if params[:action] == 'introduction' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Introduction', 'path': practice_introduction_path(practice_by_practice_id) }
    end

    # Adoptions breadcrumbs
    if params[:action] == 'adoptions' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Adoptions', 'path': practice_adoptions_path(practice_by_practice_id) }
    end

    # Overview breadcrumbs
    if params[:action] == 'overview' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Overview', 'path': practice_overview_path(practice_by_practice_id) }
    end

    # Implementation breadcrumbs
    if params[:action] == 'implementation' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Implementation', 'path': practice_implementation_path(practice_by_practice_id) }
    end

    # Contact breadcrumbs
    if params[:action] == 'contact' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'Contact', 'path': practice_contact_path(practice_by_practice_id) }
    end

    # About breadcrumbs
    if params[:action] == 'about' && params[:controller] == 'practices'
      reset_editor_breadcrumbs(practice_by_practice_id)
      session[:breadcrumbs] << { 'display': 'About', 'path': practice_about_path(practice_by_practice_id) }
    end
  end
end