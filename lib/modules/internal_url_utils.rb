module InternalUrlUtils
  def validate_url(url)
    # checks if url begins with a "/"
    if url.chars.first != '/'
      raise StandardError.new 'must begin with a "/"'
    end

    route = Rails.application.routes.recognize_path(url)

    if route.present?
      db_rec = get_record(route)
      return db_rec.present? ? true : throw_invalid_err
    else
      throw_invalid_err
    end
  end

  private

  def is_practice_edit_action(action)
    pr_edit_actions = ['metrics', 'instructions', 'editors', 'introduction', 'adoptions', 'overview', 'implementation', 'contact', 'about']
    pr_edit_actions.include?(action)
  end

  def is_admin_action(action)
    admin_actions = ['show', 'edit']
    admin_actions.include?(action)
  end

  def throw_invalid_err
    raise StandardError.new 'not a valid URL'
  end

  def get_model(controller)
    controller.classify.constantize
  end

  def get_record(route)
    db_record = nil
    # admin routes
    if route[:controller].include?('admin')
      model_str = route[:controller].split("/")[1]
      # admin dashboard
      if model_str == 'dashboard' && route[:action] == 'index'
        db_record = true
      elsif route[:action].present? && is_admin_action(route[:action])
        model = get_model(model_str)
        if model_str === 'practices'
          db_record = model.find_by(slug: route[:id])
        else
          db_record = model.find_by(id: route[:id])
        end
      else
        db_record = true
      end
    else
      # practice edit routes
      if route[:practice_id].present? && route[:action]
        model = get_model(route[:controller])
        db_record = model.find_by(slug: route[:practice_id]) if is_practice_edit_action(route[:action])
      # visn show routes
      elsif route[:number].present?
        number = route[:number].to_i
        is_number = number.to_s === route[:number]
        model = get_model(route[:controller])
        db_record = model.find_by(number: number) if is_number
      elsif route[:id].present?
        model = get_model(route[:controller])
        db_record = model.find_by(slug: route[:id])
      else
        db_record = true
      end
    end
    return db_record
  end
end
