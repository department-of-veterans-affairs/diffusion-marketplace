class SavePracticeService
  include CropperUtils

  def initialize(params)
    @practice = params[:practice]
    @practice_params = params[:practice_params]
    @avatars = ['practice_creators', 'va_employees']
    @attachments = ['impact_photos', 'additional_documents']
    @resources = ['problem_resources', 'solution_resources', 'results_resources', 'multimedia']
    @current_endpoint = params[:current_endpoint]
    @error_messages = {
        update_practice_partner_practices: 'error updating practice partners',
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

      updated = @practice.update(@practice_params)
      rescue_method(:update_practice_partner_practices)
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
    practice_partner_params = @practice_params[:practice_partner]
    practice_partners = @practice.practice_partner_practices
    if practice_partner_params.present?
      partner_keys = practice_partner_params.keys
      partner_keys.each do |key|
        next if @practice.practice_partners.ids.include? key.to_i

        practice_partners.create practice_partner_id: key.to_i
      end

      practice_partners.each do |partner|
        partner.destroy unless partner_keys.include?(partner.practice_partner_id.to_s)
      end
    elsif practice_partner_params.blank? && @current_endpoint == 'introduction'
      practice_partners.destroy_all
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
              practice_depts.find_by(id: key).update_attributes(department_id: value.to_i)
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
    if !@current_endpoint.nil? && @current_endpoint.downcase == "introduction"
      covid_category_notifications(category_params, practice_categories)
    end
    if category_params.present?
      category_attribute_params = @practice_params[:categories_attributes]
      cat_keys = category_params.keys

      cat_keys.each do |key|
        if practice_categories.ids.exclude?(key.to_i)
          practice_category_practices.find_or_create_by(category_id: key.to_i)
        end
      end
      
      other_cat_id = Category.find_by(name: 'Other').id

      if cat_keys.include?(other_cat_id.to_s)
        categories_to_process = category_attribute_params.values.map { |param| {id: param[:id], name: param[:name], _destroy: param[:_destroy]} }
        # If Other was checked, create a new category with is_other true and create a category_practice linking to the new category
        categories_to_process.each do |category|
          unless category[:name] == ""
            if category[:_destroy] == 'false' && category[:id].nil?
              cate = Category.create(name: category[:name], is_other: true)
              practice_category_practices.create(category_id: cate.id)
            elsif category[:_destroy] == 'false' && category[:id].present?
              practice_categories.find_by(id: category[:id].to_i).update_attributes(name: category[:name])
            elsif category[:_destroy] == 'true' && category[:id].present?
              practice_category_practices.where(category_id: category[:id]).destroy_all
            end
          end
        end
      end

      other_practice_categories = practice_categories.where(is_other: true)

      if other_practice_categories.any?
        if cat_keys.exclude?(other_cat_id.to_s)
          practice_category_practices.joins(:category).where(categories: {is_other: true}).destroy_all

          other_practice_categories.each do |oc|
            oc.destroy unless CategoryPractice.where.not(practice_id: @practice.id).where(category_id: oc.id).any?
          end
        end
      end

      practice_category_practices.joins(:category).where(categories: {is_other: false}).each do |pcp|
        pcp.destroy unless cat_keys.include?(pcp.category_id.to_s)
      end

    elsif category_params.blank? && @current_endpoint == 'introduction'
      practice_category_practices.destroy_all
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
        if cur_cat.name.upcase.include?(dm)
          selected_categories_obj.push(cur_cat)
          next
        end
      end
    end
    categories_unselected.each do |cu|
      cur_cat = Category.find_by(id: cu)
      dm_notification_categories.each do |dm|
        if cur_cat.name.upcase.include?(dm)
          unselected_categories_obj.push(cur_cat)
          next
        end
      end
    end
    if unselected_categories_obj.present? || selected_categories_obj.present?
      CovidCategoryMailer.send_covid_category_selections(selected_categories: selected_categories_obj, unselected_categories: unselected_categories_obj, practice_name: @practice.name, url: "#{ENV.fetch('HOSTNAME')}/practices/#{@practice.slug}").deliver_now
    end
  end

  def remove_attachments
    @attachments.each do |attachment|
      attribute = ("#{attachment}_attributes").to_sym

      if @practice_params[attribute].present?
        @practice_params[attribute].each do |key, e|
          if e['delete_attachment'] == 'true'
            record = @practice.send(attachment).find(e[:id])
            record.update_attributes(attachment: nil)
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
              record.update_attributes(avatar: nil)
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
      @practice.update_attributes(main_display_image: nil)
    end
  end

  def crop_main_display_image
    if is_cropping?(@practice_params)
      @practice.main_display_image.reprocess!
    end
  end

  def update_initiating_facility
    initiating_facility_type = @practice_params[:initiating_facility_type]
    initiating_facility = @practice_params[:initiating_facility]
    if initiating_facility_type.present? && initiating_facility.present?
      if initiating_facility_type != 'department'
        @practice.update_attributes(initiating_department_office_id: nil)
      end
      # if @current_endpoint == 'overview'
      if initiating_facility_type.present? && initiating_facility.present?
        @practice.update_attributes({initiating_facility_type: initiating_facility_type, initiating_facility: initiating_facility})
      else
        raise StandardError.new @error_messages[:update_initiating_facility]
      end
      # end
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
end
