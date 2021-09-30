module UserUtils
  def skip_validations_and_save_user(user)
    # set the user's attributes based on ldap entry
    user.skip_password_validation = true
    user.skip_va_validation = true
    # TODO: public site: do we want created users to confirm their accounts?
    user.confirm unless ENV['USE_NTLM'] == 'true'
    user.save
  end

  def is_invalid_va_email(email)
    email.split('@').last != 'va.gov'
  end
end