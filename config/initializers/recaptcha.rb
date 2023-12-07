Recaptcha.configure do |config|
    if Rails.env.test?
        config.skip_verify_env << 'test'
    else
        config.site_key  = ENV['RECAPTCHA_SITE_KEY_V3']
        config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
    end
end
