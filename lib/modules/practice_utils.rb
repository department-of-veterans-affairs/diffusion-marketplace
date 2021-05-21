module PracticeUtils
  def practices_json(practices)
    practices_array = []

    practices.each do |practice|
      practice_hash = JSON.parse(practice.to_json) # convert to hash
      practice_hash['image'] = practice.main_display_image.present? ? practice.main_display_image_s3_presigned_url : ''
      if practice.date_initiated
        practice_hash['date_initiated'] = practice.date_initiated.strftime("%B %Y")
      else
        practice_hash['date_initiated'] = '(start date unknown)'
      end

      if practice.categories&.size > 0
        practice_hash['category_names'] = []
        categories = practice.categories.not_other.not_none
        categories.each do |category|
          practice_hash['category_names'].push category.name

          unless category.related_terms.empty?
            practice_hash['category_names'].concat(category.related_terms)
          end
        end
      end

      # display initiating facility
      practice_hash['initiating_facility_name'] = helpers.origin_display(practice)
      practice_hash['initiating_facility'] = practice.initiating_facility
      origin_facilities = practice.practice_origin_facilities.pluck(:facility_id)
      practice_hash['origin_facilities'] = origin_facilities
      practice_hash['user_favorited'] = current_user.favorite_practice_ids.include?(practice.id) if current_user.present?

      # get diffusion history facilities
      adoptions = practice.diffusion_histories.pluck(:facility_id)
      practice_hash['adoption_facilities'] = adoptions
      practices_array.push practice_hash
    end

    practices_array.to_json.html_safe
  end

  def get_categories_by_practices(practices, practice_categories)
    practices.each do |p|
      categories = p.categories.not_other.not_none
      categories.each do |c|
        practice_categories << c unless practice_categories.include?(c)
      end
    end
    practice_categories.sort_by! { |pc| pc.name.downcase }
  end
end
