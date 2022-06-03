class SavePracticeService
  include CropperUtils
  include UserUtils
  include UsersHelper

  def initialize(params)
    @practice = params[:practice]
    @practice_params = params[:practice_params]
    @avatars = ['practice_creators', 'va_employees']
    @attachments = ['impact_photos', 'additional_documents']
    @resources = ['problem_resources', 'solution_resources', 'results_resources', 'multimedia']
    @current_endpoint = params[:current_endpoint]
    @error_messages = {
        update_department_practices: 'error updating departments',
        remove_attachments: 'error removing attachments',
        manipulate_avatars: 'error updating avatars',
        remove_main_display_image: 'error removing practice thumbnail',
        crop_main_display_image: 'error cropping practice thumbnail',
        update_initiating_facility: 'error updating initiating facility',
        update_practice_awards: 'error updating practice awards',
        update_category_practices: 'error updating practice categories',
        crop_resource_images: 'error cropping practice resource images'
    }
  end

  def save_practice
    begin
      if @practice_params["practice_problem_resources_attributes"].present?
        process_problem_resource_params
      end
      if @practice_params["practice_solution_resources_attributes"].present?
        process_solution_resource_params
      end
      if @practice_params["practice_results_resources_attributes"].present?
        process_results_resource_params
      end
      if @practice_params["practice_multimedia_attributes"].present?
        process_multimedia_params
      end
      if @practice_params["practice_resources_attributes"].present?
        process_practice_resources_params
      end
      if @practice_params["risk_mitigations_attributes"].present?
        process_risk_mitigations_params
      end
      if @practice_params["practice_editors_attributes"].present?
        update_practice_editors
      end

      if @practice_params["categories_attributes"].present?
        process_categories_params
      end

      if @practice_params["initiating_facility_type"].present?
        update_initiating_facility
      end

      if @practice_params["practice_origin_facilities_attributes"].present?
        filter_practice_origin_facilities
      end

      if @practice_params["practice_partner_practices_attributes"].present?
        update_practice_partner_practices
      end

      # if the user tries to add alt text for the main display image when they have not yet uploaded one, do not save the text
      if @practice_params[:main_display_image_alt_text].present? && @practice_params[:main_display_image].nil? && !@practice.main_display_image.present?
        @practice_params[:main_display_image_alt_text] = nil
      end

      updated = @practice.update(@practice_params)
      rescue_method(:update_department_practices)
      rescue_method(:remove_attachments)
      rescue_method(:manipulate_avatars)
      rescue_method(:remove_main_display_image)
      rescue_method(:crop_main_display_image)
      rescue_method(:update_initiating_facility)
      rescue_method(:update_practice_awards)
      rescue_method(:update_category_practices)
      rescue_method(:crop_resource_images)

      if updated
        practice = Practice.find_by_id(@practice.id)
        practice.practice_pages_updated = DateTime.now()
        practice.save()
      end
      updated
    rescue => e
        Rails.logger.error "save_practice error: #{e.message}"
      e
    end
  end

  private

  attr_accessor :flash

  def rescue_method(method_name)
    begin
      send(method_name)
    rescue StandardError => e
      puts e
      raise StandardError.new @error_messages[method_name]
    end
  end

  def crop_resource_images
    @resources.each do |resource|
      res_name = "practice_#{resource}"
      params_resources = @practice_params["#{res_name}_attributes"]
      if params_resources
        params_resources.each do |r|
          if is_cropping?(r[1]) && r[1][:_destroy] == 'false' && r[1][:id].present?
            r_id = r[1][:id].to_i
            record = @practice.send(res_name).find(r_id)
            reprocess_attachment(record, r[1])
          end
        end
      end
    end
  end

  def update_practice_partner_practices
    practice_partner_params = @practice_params[:practice_partner_practices_attributes]
    practice_partner_params_data = Params::ParamsData.new(practice_partner_params)
    modify_practice_partner_params = Params::ModifyParams.new(practice_partner_params)
    partner_id_counts = practice_partner_params_data.get_id_counts_from_params(:practice_partner_id)
    unsaved_practice_partner_ids = []

    begin
      practice_partner_params.each do |key, value|
        partner_id = value[:practice_partner_id]
        existing_practice_partner = @practice.practice_partners.where(id: partner_id.to_i).first
        has_duplicate_partner_params = partner_id_counts[partner_id] > 1
        # if the user tries to change an existing partner to another existing partner, raise an error
        if practice_partner_params_data.has_two_existing_records_with_identical_param_values?(:practice_partner_id, partner_id)
          raise StandardError.new
        end

        # if the user tries to delete an existing partner and create a new identical partner, keep the original record and remove the corresponding partners that are not yet created
        if has_duplicate_partner_params && existing_practice_partner.present?
          duplicate_practice_partners_to_be_created = practice_partner_params.select { |hash_key, hash_value| hash_value[:practice_partner_id] === partner_id }.keys
          # remove all of the keys that have a practice_partner_id value that match the current partner_id and reset the counts
          modify_practice_partner_params.delete_duplicate_params_and_reset_param_id_counts(duplicate_practice_partners_to_be_created, partner_id_counts, partner_id)
        end

        # prevent duplicate practice partner creation when a user tries to submit more than one of the same would-be partner and reset the counts
        if (unsaved_practice_partner_ids.include?(partner_id)) || (existing_practice_partner.present? && has_duplicate_partner_params)
          modify_practice_partner_params.delete_param_and_reset_param_id_counts(key, partner_id_counts, partner_id)
        else
          unsaved_practice_partner_ids << partner_id unless partner_id.nil?
        end
      end
    rescue
      raise StandardError.new 'error updating practice partners'
    end
  end

  def update_department_practices
    dept_params = @practice_params[:department]
    practice_depts = @practice.department_practices
    if dept_params.present?
      dept_keys = dept_params.keys
      dept_ids = Array.new
      practice_depts.each do |v|
        dept_ids.push(v[:department_id].to_s)
      end
      dept_keys.each do |key|
        value = dept_params[key][:value]
        destroy = dept_params[key][:_destroy] === 'true'
        if destroy === false
          if dept_ids.include? value
            next
          else
            dept_ids.push(value)
          end
        end
        if value || destroy
          if key.include? 'new_department_practice'
            practice_depts.create department_id: value.to_i
          elsif practice_depts.ids.include? key.to_i
            if destroy
              practice_depts.find_by(id: key).destroy!
            else
              practice_depts.find_by(id: key).update(department_id: value.to_i)
            end
          end
        end
      end
    end
  end

  def update_category_practices
    category_params = @practice_params[:category]
    practice_category_practices = @practice.category_practices
    practice_categories = @practice.categories
    if @current_endpoint.present? && @current_endpoint.downcase == "introduction"
      covid_category_notifications(category_params, practice_categories)
    end
    if category_params.present?
      category_attribute_params = @practice_params[:categories_attributes]
      cat_keys = category_params.keys

      cat_keys.each do |key|
        if practice_categories.ids.exclude?(key.to_i) && !key.include?('other')
          practice_category_practices.find_or_create_by(category_id: key.to_i)
        end
      end

      other_parent_cats = []
      cat_keys.each { |ck| if ck.include?('other') then other_parent_cats << Category.get_category_by_name(ck.split('-').pop).first end }
      if other_parent_cats.present?
        category_attribute_params.values.each do |category|
          # If Other was checked, create a new category with is_other true and create a category_practice linking to the new category
          id = category[:id]
          destroy = category[:_destroy]
          name = category[:name]
          parent_cat_id_param = category[:parent_category_id]
          # if the 'other' category has not yet been created, the :parent_category_id will be a string, so we need to find the corresponding parent category
          parent_cat_id = parent_cat_id_param.to_i === 0 ? Category.get_category_by_name(parent_cat_id_param).first.id : parent_cat_id_param
          unless name == ""
            if destroy != '1' && id.blank?
              cate = Category.find_by(name: name.strip, is_other: true, parent_category_id: parent_cat_id)
              cate = Category.create(name: name.strip, is_other: true, parent_category_id: parent_cat_id) unless cate.present?
              CategoryPractice.find_or_create_by(category: cate, practice: @practice)
            elsif destroy != '1' && id.present?
              practice_categories.find_by(id: id.to_i).update(name: name.strip, parent_category_id: parent_cat_id)
            elsif destroy == '1' && id.present?
              practice_category_practices.where(category_id: id).destroy_all
              Category.find(id).destroy if CategoryPractice.where(category_id: id).where('practice_id != ?', @practice.id).blank?
            end
          end
        end
      end
      other_practice_categories = practice_categories.where(is_other: true)
      if other_practice_categories.any?
        other_parent_cat_options = ['other-clinical', 'other-operational', 'other-strategic']
        other_parent_cat_options.each do |opc|
          parent_cat = Category.get_category_by_name(opc.split('-').pop).first
          if cat_keys.exclude?(opc)
            other_practice_categories.each do |oc|
              if oc.parent_category == parent_cat && CategoryPractice.where(category: oc).where('practice_id != ?', @practice.id).blank?
                oc.destroy
              end
            end
            practice_category_practices.joins(:category).where(categories: { parent_category_id: parent_cat.id, is_other: true }).destroy_all
          end
        end
      end

      practice_category_practices.joins(:category).where(categories: { is_other: false }).each do |pcp|
        pcp.destroy unless cat_keys.include?(pcp.category_id.to_s)
      end

    elsif category_params.blank? && @current_endpoint == 'introduction'
      practice_category_practices.each do |pcp|
        pcp.destroy
        pcp.category.destroy if CategoryPractice.where(category: pcp.category).where('practice_id != ?', @practice.id).blank?
      end
    end
  end

  def covid_category_notifications(category_params, practice_categories)
    categories_selected = Array.new
    categories_unselected = Array.new
    dm_notification_categories = ["COVID", "TELEHEALTH", "CURBSIDE CARE", "ENVIRONMENTAL SERVICES", "PULMONARY CARE", "HEALTHCARE ADMINISTRATION"]

    if category_params.blank? && practice_categories.present?
      practice_categories.each do |pc|
        categories_unselected.push(pc.id)
      end
    end
    if practice_categories.blank? && category_params.present?
      category_params.keys.each do |key|
        categories_selected.push(key.to_i)
      end
    end
    if practice_categories.present? && category_params.present?
      cat_keys = category_params.keys
      practice_categories.each do |pc|
        if cat_keys.exclude?(pc.id.to_s)
          categories_unselected.push(pc.id)
        end
      end
      cat_keys.each do |ck|
        if practice_categories.ids.exclude?(ck.to_i)
          categories_selected.push(ck.to_i)
        end
      end
    end
    selected_categories_obj = Array.new
    unselected_categories_obj = Array.new
    categories_selected.each do |cs|
      cur_cat = Category.find_by(id: cs)
      dm_notification_categories.each do |dm|
        if cur_cat.present? && cur_cat.name.upcase.include?(dm)
          selected_categories_obj.push(cur_cat)
          next
        end
      end
    end
    categories_unselected.each do |cu|
      cur_cat = Category.find_by(id: cu)
      dm_notification_categories.each do |dm|
        if cur_cat.present? && cur_cat.name.upcase.include?(dm)
          unselected_categories_obj.push(cur_cat)
          next
        end
      end
    end

    # sort the category arrays by category name
    selected_categories_obj.sort_by! { |sc| sc.name.downcase }
    unselected_categories_obj.sort_by! { |uc| uc.name.downcase }

    if unselected_categories_obj.present? || selected_categories_obj.present?
      CovidCategoryMailer.send_covid_category_selections(selected_categories: selected_categories_obj, unselected_categories: unselected_categories_obj, practice_name: @practice.name, url: "#{ENV.fetch('HOSTNAME')}/innovations/#{@practice.slug}").deliver_now
    end
  end

  def remove_attachments
    @attachments.each do |attachment|
      attribute = ("#{attachment}_attributes").to_sym

      if @practice_params[attribute].present?
        @practice_params[attribute].each do |key, e|
          if e['delete_attachment'] == 'true'
            record = @practice.send(attachment).find(e[:id])
            record.update(attachment: nil)
          end
        end
      end
    end
  end

  def manipulate_avatars
    @avatars.each do |avatar|
      attribute = ("#{avatar}_attributes").to_sym

      if @practice_params[attribute].present?
        @practice_params[attribute].each do |key, e|
          if e[:_destroy] == 'false' && e[:id].present?
            record = @practice.send(avatar).find(e[:id])

            # Remove avatar
            if e['delete_avatar'] == 'true'
              record.update(avatar: nil)
            end

            # Crop avatar
            if is_cropping?(e)
              reprocess_avatar(record, e)
            end
          end
        end
      end
    end
  end

  def remove_main_display_image
    if @practice_params[:delete_main_display_image].present? && @practice_params[:delete_main_display_image] == 'true'
      @practice.update(main_display_image: nil, main_display_image_alt_text: nil)
    end
  end

  def crop_main_display_image
    if is_cropping?(@practice_params)
      @practice.main_display_image.reprocess!
    end
  end

  def update_initiating_facility
    initiating_facility_type = @practice_params[:initiating_facility_type]
    initiating_facility = @practice.initiating_facility
    if @current_endpoint === 'introduction'
      if initiating_facility_type.present? && initiating_facility.present?
        if initiating_facility_type != 'department'
          @practice.update(initiating_department_office_id: nil)
        end
        @practice.update({initiating_facility_type: initiating_facility_type, initiating_facility: initiating_facility})
      elsif initiating_facility.blank? && @practice_params[:practice_origin_facilities_attributes].nil?
        raise StandardError.new @error_messages[:update_initiating_facility]
      end
    end
  end

  def update_practice_awards
    practice_award_params = @practice_params[:practice_award]
    practice_awards = @practice.practice_awards
    if practice_award_params
      practice_awards_to_create = practice_award_params.values.map { |param| param[:name] }
      practice_awards_to_create.each { |award| @practice.practice_awards.find_or_create_by(name: award) }

      # get practice awards that are in the provided list
      # figure out which ones are not in the params and delete the award if the practice has it made
      Practice::PRACTICE_EDITOR_AWARDS_AND_RECOGNITION.each do |defined_award|
        # check if the award is in the params, delete award if it is not in the params
        practice_awards.find_by(name: defined_award)&.destroy unless practice_awards_to_create.include?(defined_award)

        # if "Other" was not checked, destroy all "Other" awards
        if defined_award == 'Other' && !practice_awards_to_create.include?(defined_award)
          other_awards = practice_awards.where.not(name: Practice::PRACTICE_EDITOR_AWARDS_AND_RECOGNITION)
          other_awards.destroy_all
        end
      end
    elsif practice_award_params.blank? && @current_endpoint == 'introduction' && practice_awards.any?
      practice_awards.destroy_all
    end
  end

  def process_problem_resource_params
    PracticeProblemResource.resource_types.each do |rt|
      @practice_params['practice_problem_resources_attributes']&.delete('RANDOM_NUMBER_OR_SOMETHING_' + rt[0])
    end
  end

  def process_solution_resource_params
    PracticeSolutionResource.resource_types.each do |rt|
      @practice_params['practice_solution_resources_attributes']&.delete('RANDOM_NUMBER_OR_SOMETHING_' + rt[0])
    end
  end

  def process_results_resource_params
    PracticeResultsResource.resource_types.each do |rt|
      @practice_params['practice_results_resources_attributes']&.delete('RANDOM_NUMBER_OR_SOMETHING_' + rt[0])
    end
  end

  def process_multimedia_params
    PracticeMultimedium.resource_types.each do |rt|
      @practice_params['practice_multimedia_attributes']&.delete('RANDOM_NUMBER_OR_SOMETHING_' + rt[0])
    end
  end

  def process_practice_resources_params
    PracticeResource.media_types.each do |rt|
      @practice_params['practice_resources_attributes']&.delete('RANDOM_NUMBER_OR_SOMETHING_' + rt[0])
      @practice_params['practice_resources_attributes']&.delete('RANDOM_NUMBER_OR_SOMETHING_' + rt[0] + '_core')
      @practice_params['practice_resources_attributes']&.delete('RANDOM_NUMBER_OR_SOMETHING_' + rt[0] + '_optional')
      @practice_params['practice_resources_attributes']&.delete('RANDOM_NUMBER_OR_SOMETHING_' + rt[0] + '_support')
    end
  end

  def process_risk_mitigations_params
    @practice_params["risk_mitigations_attributes"].each do |rm|
      if rm[1][:_destroy] == 'false'
        risk_desc = rm[1][:risks_attributes]["0"][:description]
        miti_desc = rm[1][:mitigations_attributes]["0"][:description]

        if risk_desc.empty? || miti_desc.empty?
          @practice_params["risk_mitigations_attributes"].delete(rm[0])
        end
      end
    end
  end

  def update_practice_editors
    editors = @practice_params[:practice_editors_attributes]
    includes_destroy = editors.keys.include?('_destroy')
    if includes_destroy
      editor_count = @practice.practice_editors.count
      # delete practice editor if there is at least one left after deletion. If not, raise an error.
      if editor_count > 1
        PracticeEditor.find_by(id: editors[:id]).destroy
      else
        raise StandardError.new "error. At least one editor is required"
      end
    else
      email_param = editors.values.first.values.first.downcase
      user = User.find_by(email: email_param)
      practice_editor = PracticeEditor.find_by(practice: @practice, user: user)

      # if the user tries to save with a blank email field, raise an error
      raise StandardError.new "error. Email field cannot be blank" if email_param.blank?
      # if the user tries to save with an invalid email field, raise an error
      raise StandardError.new "There was an error. Must be a valid @va.gov email address" if is_invalid_va_email(email_param)

      if user.present? && practice_editor.nil?
        # create a new practice editor for the existing user
        PracticeEditor.create_and_invite(@practice, user)
      # make sure a duplicate practice editor is not created
      elsif user.present? && practice_editor.present?
        raise StandardError.new "error. A user with the email \"#{user.email}\" is already an editor for this practice"
      else
        # create a new user if they do not exist
        user = User.new(email: email_param)
        skip_validations_and_save_user(user)
        # create a new practice editor for the new user
        PracticeEditor.create_and_invite(@practice, user)
      end
    end
    # remove params keys before updating practice
    editors.keys.each do |k|
      editors.delete(k)
    end
  end

  # if a blank 'other' category entry is sent in the request params, delete it prior to updating the practice
  def process_categories_params
    @practice_params["categories_attributes"].each do |cat|
      cat_hash = cat[1]
      if cat_hash[:_destroy] == 'false' && cat_hash[:name].blank? && cat_hash[:id].blank?
        @practice_params["categories_attributes"].delete(cat[0])
      end
    end
  end

  def filter_practice_origin_facilities
    origin_facility_params = @practice_params[:practice_origin_facilities_attributes]
    origin_facility_params_data = Params::ParamsData.new(origin_facility_params)
    modify_origin_facility_params = Params::ModifyParams.new(origin_facility_params)
    unsaved_va_facility_ids = []
    unsaved_crh_ids = []

    begin
      origin_facility_params.each do |key, value|
        facility_id = value[:facility_id]

        facility_type_and_id = value[:facility_type_and_id]
        practice_origin_facilities = @practice.practice_origin_facilities

        # if the user tries to change an existing facility to another existing facility, raise an error
        raise StandardError.new if origin_facility_params_data.has_two_existing_records_with_identical_param_values?(:facility_id, facility_id)

        if facility_id.present?
          if facility_id.start_with?('va-facility')
            value[:va_facility_id] = facility_id.split('-').last
            va_facility_id = value[:va_facility_id]
            # if there's an existing origin facility that's being changed from a CRH to a VaFacility, we need to assign the new va_facility_id and set the clinical_resource_hub_id to nil,
            # because a PracticeOriginFacility cannot have both foreign keys populated
            if value[:id].present? && facility_type_and_id.start_with?('crh') && value[:_destroy] === 'false'
              practice_origin_facility = PracticeOriginFacility.find_by(practice_id: @practice.id, clinical_resource_hub_id: facility_type_and_id.split('-').last)
              practice_origin_facility.update_attributes(clinical_resource_hub_id: nil, va_facility_id: facility_id.split('-').last)
            end
          else
            value[:clinical_resource_hub_id] = facility_id.split('-').last
            crh_id = value[:clinical_resource_hub_id]
            # if there's an existing origin facility that's being changed from a VaFacility to a CRH, we need to assign the new clinical_resource_hub_id and set the va_facility_id to nil
            # because a PracticeOriginFacility cannot have both foreign keys populated
            if value[:id].present? && facility_type_and_id.start_with?('va-facility') && value[:_destroy] === 'false'
              practice_origin_facility = PracticeOriginFacility.find_by(practice_id: @practice.id, va_facility_id: facility_type_and_id.split('-').last)
              practice_origin_facility.update_attributes(va_facility_id: nil, clinical_resource_hub_id: facility_id.split('-').last)
            end
          end
          value[:facility_id] = facility_id.split('-').last
        end

        facility_id_counts = origin_facility_params_data.get_id_counts_from_params(:facility_id)

        # check for an existing origin facility record
        if va_facility_id.present? || crh_id.present?
          existing_origin_facility = va_facility_id.present? ? practice_origin_facilities.find_by(va_facility_id: va_facility_id.to_i) :
                                     practice_origin_facilities.find_by(clinical_resource_hub_id: crh_id.to_i)
        end

        has_duplicate_origin_facility_params = va_facility_id.present? ? facility_id_counts[va_facility_id] > 1 : facility_id_counts[crh_id] > 1
        # if the user tries to delete an existing origin facility and create a new identical origin facility, keep the original record and remove the corresponding origin facilities that are not yet created
        if has_duplicate_origin_facility_params && existing_origin_facility.present?
          duplicate_origin_facilities_to_be_created = origin_facility_params.select do |hash_key, hash_value|
            if hash_value[:va_facility_id].present?
              hash_value[:va_facility_id] === va_facility_id
            else
              hash_value[:clinical_resource_hub_id] === crh_id
            end
          end
          # remove all of the keys that have a va_facility_id or clinical_resource_hub_id value that match the current va_facility_id or clinical_resource_hub_id and reset the counts
          modify_origin_facility_params.delete_deep_duplicate_params(duplicate_origin_facilities_to_be_created)
          va_facility_id.present? ? modify_origin_facility_params.reset_param_id_counts(facility_id_counts, va_facility_id) :
            modify_origin_facility_params.reset_param_id_counts(facility_id_counts, crh_id)
        end

        # prevent duplicate origin facility creation when a user tries to submit more than one of the same would-be origin facility and reset the counts
        if va_facility_id.present?
          if (unsaved_va_facility_ids.include?(va_facility_id)) || (existing_origin_facility.present? && has_duplicate_origin_facility_params)
            modify_origin_facility_params.delete_param_and_reset_param_id_counts(key, facility_id_counts, va_facility_id)
          else
            unsaved_va_facility_ids << va_facility_id unless va_facility_id.nil?
          end
        elsif crh_id.present?
          if (unsaved_crh_ids.include?(crh_id)) || (existing_origin_facility.present? && has_duplicate_origin_facility_params)
            modify_origin_facility_params.delete_param_and_reset_param_id_counts(key, facility_id_counts, crh_id)
          else
            unsaved_crh_ids << crh_id unless crh_id.nil?
          end
        end
      end
    rescue
      raise StandardError.new 'error updating practice origin facilities'
    end
  end
end
