module ActiveAdminUtils
  def update_boolean_attr(attr, message_1, message_2)
    message = "\"#{resource.name}\" #{message_1}"

    unless attr
      message = "\"#{resource.name}\" #{message_2}"
    end

    resource.save
    redirect_back fallback_location: root_path, notice: message
  end
end