module NavigationHelper
  PRACTICE_EDITOR_PAGES =  ['editors', 'introduction', 'adoptions', 'overview', 'implementation', 'about']
  PRODUCT_EDITOR_PAGES = ['editors', 'description','intrapreneur','multimedia']
  INNOVATION_EDITOR_PAGES = PRACTICE_EDITOR_PAGES + PRODUCT_EDITOR_PAGES.uniq

  def setup_breadcrumb_navigation
    session[:breadcrumbs] = session[:breadcrumbs] || []
    session[:heading] = nil
    session[:description] = nil
    session[:page_image] = nil
    session[:page_image_alt_text] = nil
    action = params[:action]
    controller = params[:controller]

    def empty_breadcrumbs
      session[:breadcrumbs].clear
    end

    if controller == 'devise/sessions'
      empty_breadcrumbs
    end

    ### HOMEPAGE BREADCRUMBS
    if controller == 'home'
      # reset if home page
      if action == 'index'
        empty_breadcrumbs
        return
      end

      # Diffusion map
      if action == 'diffusion_map'
        empty_breadcrumbs
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
      session[:breadcrumbs] << { 'practice': 'true', 'display': practice.name, 'path': practice_path(practice) }.stringify_keys
    end

    def remove_breadcrumb(crumb)
      session[:breadcrumbs].slice!(session[:breadcrumbs].index(crumb))
    end

    def add_visn_index_breadcrumb
      session[:breadcrumbs] << { 'display': 'VISN index', 'path': visns_path }
    end

    ### PRACTICE BREADCRUMBS
    if controller == 'practices'
      if action == 'index'
        # empty the bread crumbs and start a new path
        empty_breadcrumbs
        session[:breadcrumbs] << {'display': 'Innovations', 'path': '/innovations'}
      end

      search_breadcrumb = session[:breadcrumbs].find { |bc| bc['display'] == 'Search' || bc[:display] == 'Search' } || nil
      url = URI::parse(request.referer || '')

      # search page
      if action == 'search'
        empty_breadcrumbs
        session[:breadcrumbs] << {'display': 'Search', 'path': search_path}
      end

      # add the search breadcrumb if there is a search query going to the practice page
      if action == 'show' && url.path.include?('search') && (url.query.present? && url.query.include?('query='))
        empty_breadcrumbs
        search_breadcrumb['path'] = "#{url.path}?#{url.query}" if search_breadcrumb.present?
        session[:breadcrumbs] << {'display': 'Search', 'path': "#{url.path}?#{url.query}"}
        add_practice_breadcrumb(practice_by_id)
      end

      def add_visn_search_breadcrumb(visn_number, url)
        session[:breadcrumbs] << { 'display': visn_number, 'path': "#{url.path}?#{url.query}" }
      end

      # add the VISN search query to breadcrumb if there is a VISN search query going to the practice page
      if action == 'show' && (url.query.present? && url.query.include?('query=')) && url.to_s.split('?').first.last.to_i.between?(1, 23)
        visn_number = session[:breadcrumbs].last['path'].split('/').pop

        empty_breadcrumbs
        add_visn_index_breadcrumb
        add_visn_search_breadcrumb(visn_number, url)
        add_practice_breadcrumb(practice_by_id)
      end

      # practice path
      if action == 'show'
        # Failsafe in the event a user is on the search page but travels to a practice page via the url bar
        if search_breadcrumb.present? && search_breadcrumb['path'] == ''
          search_breadcrumb['path'] = search_path
        end

        if practice_breadcrumb(practice_by_id).blank?
          # remove first practice if there is more than one in the breadcrumbs (to prevent too many crumbs)
          session[:breadcrumbs].delete_if { |bc| bc['practice'].present? }
          add_practice_breadcrumb(practice_by_id)
          # If there are any duplicate breadcrumbs, delete them
        elsif practice_breadcrumb(practice_by_id).present? && practice_breadcrumb(practice_by_id).count > 1
          remove_breadcrumb(practice_breadcrumb(practice_by_id))
          add_practice_breadcrumb(practice_by_id)
        end
      end

      ### PRACTICE EDITOR BREADCRUMBS ###
      # Instructions breadcrumbs
      if action == 'instructions'
        empty_breadcrumbs
      end

      if action == 'metrics'
        empty_breadcrumbs
      end

      # Editors breadcrumbs
      if action == 'editors'
        empty_breadcrumbs
      end

      # Introduction breadcrumbs
      if action == 'introduction'
        empty_breadcrumbs
      end

      # Adoptions breadcrumbs
      if action == 'adoptions'
        empty_breadcrumbs
      end

      # Overview breadcrumbs
      if action == 'overview'
        empty_breadcrumbs
      end

      # Implementation breadcrumbs
      if action == 'implementation'
        empty_breadcrumbs
      end

      # About breadcrumbs
      if action == 'about'
        empty_breadcrumbs
      end
    end

    ### PRODUCTS
    if controller == 'products'
      if action == 'show'
        empty_breadcrumbs # TODO: add home breadcrumbs after DM-5001
      end
    end

    ### VAMC breadcrumbs
    def add_facility_index_breadcrumb
      session[:breadcrumbs] << { 'display': 'Healthcare facility index', 'path': va_facilities_path }
    end

    if controller == 'va_facilities'
      if action == 'index'
        empty_breadcrumbs
      end

      if action == 'show'
        va_facility = VaFacility.find_by!(slug: params[:id])
        empty_breadcrumbs
        add_facility_index_breadcrumb
        common_name = va_facility.common_name
        session[:breadcrumbs] << { 'display': common_name, 'path': va_facility_path(va_facility) }
      end
    end

    if controller == 'clinical_resource_hubs'
      if action == 'show'
        empty_breadcrumbs
        add_facility_index_breadcrumb
      end
    end

    ### PRACTICE PARTNER BREADCRUMBS
    def add_partners_breadcrumb
      session[:breadcrumbs] << { 'display': 'Partners', 'path': practice_partners_path }
    end

    if controller == 'practice_partners'
      # practice partner show path
      if action == 'show'
        empty_breadcrumbs
        # add the practice partner to the crumbs if it's not there already
        @practice_partner = PracticePartner.cached_practice_partners.friendly.find(params[:id])
        partner_breadcrumb = session[:breadcrumbs].find { |b| b['display'] == @practice_partner.name }

        heading = @practice_partner.name + (@practice_partner.short_name.present? ? " (#{@practice_partner.short_name.upcase})" : '')
        session[:heading] = heading

        if partner_breadcrumb.blank?
          add_partners_breadcrumb
          session[:breadcrumbs] << { 'display': @practice_partner.name, 'path': practice_partner_path(@practice_partner) }
          # If there are any duplicate practice partner name breadcrumbs, delete them
        elsif partner_breadcrumb.present? && partner_breadcrumb.count > 1
          remove_breadcrumb(partner_breadcrumb)
          add_partners_breadcrumb
          session[:breadcrumbs] << { 'display': @practice_partner.name, 'path': practice_partner_path(@practice_partner) }
        end
      end
    end

    ### PAGE-BUILDER BREADCRUMBS
    if controller == 'page'
      if action == 'show'
        @page_slug = params[:page_slug] ? params[:page_slug] : 'home'
        @page_group_slug = params[:page_group_friendly_id]
        @page_group = PageGroup.find_by(slug: @page_group_slug)
        @page = Page.find_by(slug: @page_slug, page_group: @page_group.id)
        @builder_landing_page = @page_group.landing_page
        @builder_page_path = "/#{@page_group_slug}/#{@page_slug}"

        def add_landing_page_breadcrumb(path)
          session[:breadcrumbs] << { 'display': "#{@page_group.name}", 'path': path }
        end

        if @page_slug == 'home'
          empty_breadcrumbs
        elsif @page_group.is_community?
          empty_breadcrumbs
        elsif @builder_landing_page.present?
          empty_breadcrumbs
          add_landing_page_breadcrumb("/#{@page_group_slug}")
        else
          empty_breadcrumbs
        end

        if @page.is_visible?
          session[:heading] = @page.title
          session[:description] = @page.description
          if @page.image.present?
            session[:page_image] = @page.image_s3_presigned_url(:thumb)
            session[:page_image_alt_text] = @page.image_alt_text
          end
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
        session[:breadcrumbs] << { 'display': 'Profile', 'path': user_path(current_user) } if current_user.present?
      end

      if action == 'edit_profile' && current_user.present?
        empty_breadcrumbs
        add_profile_breadcrumb
        session[:breadcrumbs] << { 'display': 'Edit', 'path': edit_profile_path } if current_user.present?
      end
    end

    # remove breadcrumbs from 'Nominate a practice' page
    if controller == 'nominate_practices' && action == 'index'
      empty_breadcrumbs
    end

    ### VISN BREADCRUMBS
    def visn_by_number
      Visn.find_by!(number: params[:number])
    end

    if controller == 'visns'
      if action == 'index'
        empty_breadcrumbs
      end

      if action == 'show'
        empty_breadcrumbs
        add_visn_index_breadcrumb
        session[:breadcrumbs] << { 'display': "#{params[:number]}", 'path': visn_path(visn_by_number) }
      end
    end

    # remove breadcrumbs from 'About' page
    if controller == 'about' && action == 'index'
      empty_breadcrumbs
    end

    # remove breadcrumbs from 'Terms and conditions' page
    if controller == 'terms_and_conditions' && action == 'index'
      empty_breadcrumbs
    end

    # remove breadcrumbs from any custom error page
    if controller === 'errors'
      empty_breadcrumbs
    end
  end
end