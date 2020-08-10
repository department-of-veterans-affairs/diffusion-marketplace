class SavePracticeService
  include CropperUtils

  def initialize(params)
    @practice = params[:practice]
    @practice_params = params[:practice_params]
    @avatars = ['practice_creators', 'va_employees']
    @attachments = ['impact_photos', 'additional_documents']
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
        update_practice_problem_resources: 'error updating practice problem resources'
    }
  end

  def save_practice
    begin
      debugger
      process_problem_resource_params
      debugger
      updated = @practice.update(@practice_params)

      rescue_method(:update_practice_partner_practices)
      rescue_method(:update_department_practices)
      rescue_method(:remove_attachments)
      rescue_method(:manipulate_avatars)
      rescue_method(:remove_main_display_image)
      rescue_method(:crop_main_display_image)
      rescue_method(:update_initiating_facility)
      rescue_method(:update_practice_awards)
      rescue_method(:update_practice_problem_resources)

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
    rescue
      raise StandardError.new @error_messages[method_name]
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
    elsif practice_partner_params.blank? && @current_endpoint == 'overview'
      practice_partners.destroy_all
    end
  end

  def update_department_practices
    department_params = @practice_params[:department]
    practice_departments = @practice.department_practices
    if department_params.present?
      dept_keys = department_params.keys
      dept_keys.each do |key|
        next if @practice.departments.ids.include? key.to_i

        @practice.department_practices.create department_id: key.to_i
      end

      practice_departments.each do |department|
        department.destroy unless dept_keys.include? department.department_id.to_s
      end
    elsif department_params.blank? && @current_endpoint == 'complexity'
      practice_departments.destroy_all
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
    @practice_params['practice_problem_resources_attributes'].delete('RANDOM_NUMBER_OR_SOMETHING')
  end

end
