class SavePracticeService
  include CropperUtils

  def initialize(params)
    @practice = params[:practice]
    @practice_params = params[:practice_params]
    @avatars = ['practice_creators', 'va_employees']
    @attachments = ['impact_photos', 'additional_documents']
  end

  def save_practice
    updated = @practice.update(@practice_params)

    update_practice_partner_practices
    update_department_practices
    remove_attachments
    manipulate_avatars
    remove_main_display_image
    crop_main_display_image

    return updated
  end

  private

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
    elsif practice_partner_params.blank? && current_endpoint == 'overview'
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
    elsif department_params.blank? && current_endpoint == 'complexity'
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
end
