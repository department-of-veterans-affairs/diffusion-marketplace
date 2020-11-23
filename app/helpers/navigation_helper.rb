module NavigationHelper
  def setup_breadcrumb_navigation
    session[:breadcrumbs] = session[:breadcrumbs] || []
    action = params[:action]
    controller = params[:controller]

    def empty_breadcrumbs
      session[:breadcrumbs] = []
    end

    ### HOMEPAGE BREADCRUMBS
    if controller == 'home'
      # reset if home page
      if action == 'index'
        session[:breadcrumbs] = []
        return
      end

      # PII/PHI
      if action == 'pii_phi_information'
        empty_breadcrumbs
        session[:breadcrumbs] << { 'display': 'PII/PHI Information', 'path': '' }
      end

      # Diffusion map
      if action == 'diffusion_map'
        empty_breadcrumbs
        session[:breadcrumbs] << { 'display': 'Map of diffusion', 'path': '' }
      end
    end

    def practice_by_id
      Practice.friendly.find(params[:id])
    end

    # This avoids the RecordNotFound error when params[:id] is not present
    def practice_by_practice_id
      Practice.friendly.find(params[:practice_id])
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

    ### PRACTICE BREADCRUMBS
    if controller == 'practices'
      if action == 'index'
        # empty the bread crumbs and start a new path
        empty_breadcrumbs
        session[:breadcrumbs] << {'display': 'Practices', 'path': '/practices'}
      end

      url = URI::parse(request.referer || '')
      # add the search breadcrumb if there is a search query going to the practice page
      if action == 'search' && url.path.include?('search') && (url.query.present? && url.query.include?('query='))
        empty_breadcrumbs
        search_breadcrumb = session[:breadcrumbs].find { |bc| bc['display'] == 'Search' || bc[:display] == 'Search'}
        search_breadcrumb['path'] = "#{url.path}?#{url.query}" if search_breadcrumb.present?
        session[:breadcrumbs] << {'display': 'Search', 'path': "#{url.path}?#{url.query}"} if search_breadcrumb.blank?
      end

      # practice path
      if action == 'show'
        if practice_breadcrumb(practice_by_id).blank?
          add_practice_breadcrumb(practice_by_id)
          # If there are any duplicate breadcrumbs, delete them
        elsif practice_breadcrumb(practice_by_id).present? && practice_breadcrumb(practice_by_id).count > 1
          remove_breadcrumb(practice_breadcrumb(practice_by_id))
          add_practice_breadcrumb(practice_by_id)
        end
      end

      # practice checklist path
      if action == 'planning_checklist'
        empty_breadcrumbs
        add_practice_breadcrumb(practice_by_practice_id)
        session[:breadcrumbs] << { 'display': 'Planning checklist', 'path': practice_planning_checklist_path(practice_by_practice_id) }
      end

      # practice committed path
      if action == 'committed'
        empty_breadcrumbs
        add_practice_breadcrumb(practice_by_practice_id)
        add_checklist_breadcrumb(practice_by_practice_id)
        session[:breadcrumbs] << { 'display': 'Confirmation', 'path': practice_committed_path(practice_by_practice_id) }
      end

      ### PRACTICE EDITOR BREADCRUMBS ###
      def instructions_breadcrumb
        session[:breadcrumbs].find { |b| b['display'] == 'Instructions' }
      end

      def add_instructions_breadcrumb(practice)
        session[:breadcrumbs] << { 'display': 'Edit', 'path': practice_instructions_path(practice) }
      end

      def reset_editor_breadcrumbs(practice)
        empty_breadcrumbs
        add_practice_breadcrumb(practice)
        add_instructions_breadcrumb(practice)
      end

      # Instructions breadcrumbs
      if action == 'instructions'
        reset_editor_breadcrumbs(practice_by_practice_id)
      end

      # Introduction breadcrumbs
      if action == 'introduction'
        reset_editor_breadcrumbs(practice_by_practice_id)
        session[:breadcrumbs] << { 'display': 'Introduction', 'path': practice_introduction_path(practice_by_practice_id) }
      end

      # Adoptions breadcrumbs
      if action == 'adoptions'
        reset_editor_breadcrumbs(practice_by_practice_id)
        session[:breadcrumbs] << { 'display': 'Adoptions', 'path': practice_adoptions_path(practice_by_practice_id) }
      end

      # Overview breadcrumbs
      if action == 'overview'
        reset_editor_breadcrumbs(practice_by_practice_id)
        session[:breadcrumbs] << { 'display': 'Overview', 'path': practice_overview_path(practice_by_practice_id) }
      end

      # Implementation breadcrumbs
      if action == 'implementation'
        reset_editor_breadcrumbs(practice_by_practice_id)
        session[:breadcrumbs] << { 'display': 'Implementation', 'path': practice_implementation_path(practice_by_practice_id) }
      end

      # Contact breadcrumbs
      if action == 'contact'
        reset_editor_breadcrumbs(practice_by_practice_id)
        session[:breadcrumbs] << { 'display': 'Contact', 'path': practice_contact_path(practice_by_practice_id) }
      end

      # About breadcrumbs
      if action == 'about'
        reset_editor_breadcrumbs(practice_by_practice_id)
        session[:breadcrumbs] << { 'display': 'About', 'path': practice_about_path(practice_by_practice_id) }
      end
    end

    ### PRACTICE PARTNER BREADCRUMBS
    if controller == 'practice_partners'
      # practice partners path
      if action == 'index'
        # empty the bread crumbs and start a new 'path'
        empty_breadcrumbs
        session[:breadcrumbs] << { 'display': 'Partners', 'path': practice_partners_path }
      end

      # practice partner show path
      if action == 'show'
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
    end

    ### PAGE-BUILDER BREADCRUMBS
    if controller == 'page'
      if action == 'show'
        @page_slug = params[:page_slug] ? params[:page_slug] : 'home'
        @page = Page.includes(:page_group).find_by(slug: @page_slug.downcase, page_groups: {slug: params[:page_group_friendly_id].downcase})
        @builder_landing_page = Page.where(slug: 'home', page_group_id: @page.page_group_id)

        def add_landing_page_breadcrumb(path)
          session[:breadcrumbs] << { 'display': "#{@page.page_group.name}", 'path': path }
        end

        def add_sub_page_breadcrumb
          session[:breadcrumbs] << { 'display': "#{@page.title}", 'path': '' }
        end

        if @page_slug == 'home'
          empty_breadcrumbs
          add_landing_page_breadcrumb('')
        elsif @builder_landing_page.exists?
          empty_breadcrumbs
          add_landing_page_breadcrumb("/#{@page.page_group.slug}")
          add_sub_page_breadcrumb
        else
          empty_breadcrumbs
          add_landing_page_breadcrumb('')
          add_sub_page_breadcrumb
        end
      end
    end

    ### REGISTRATIONS/USERS BREADCRUMBS
    # Registrations
    def add_profile_breadcrumb
      session[:breadcrumbs] << { 'display': 'Profile', 'path': user_path(current_user) }
    end

    if action == 'edit' && controller == 'registrations'
      empty_breadcrumbs
      add_profile_breadcrumb
      session[:breadcrumbs] << { 'display': 'Edit', 'path': '' }
    end

    # Users
    if controller == 'users'
      if action == 'show'
        empty_breadcrumbs
        session[:breadcrumbs] << { 'display': 'Profile', 'path': '' }
      end

      if action == 'edit_profile' && current_user.present?
        empty_breadcrumbs
        add_profile_breadcrumb
        session[:breadcrumbs] << { 'display': 'Edit', 'path': '' }
      end

      if action == 'relevant_to_you'
        empty_breadcrumbs
        session[:breadcrumbs] << { 'display': 'Relevant to you', 'path': '' }
      end
    end

    ### NOMINATE PRACTICE BREADCRUMBS
    if action == 'index' && controller == 'nominate_practices'
      empty_breadcrumbs
      session[:breadcrumbs] << { 'display': 'Nominate a practice', 'path': '' }
    end
  end
end