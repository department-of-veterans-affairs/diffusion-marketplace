module UsersHelper
  def user_full_name(user)
    "#{user.first_name} #{user.last_name}"
  end

  def is_full_name_present(user)
    user.first_name.present? && user.last_name.present?
  end

  def show_user_full_name(user)
    user_full_name(user) if is_full_name_present(user)
  end

  def show_user_full_name_or_email(user)
    if is_full_name_present(user)
      show_user_full_name(user)
    else
      "#{user.email}"
    end
  end
end