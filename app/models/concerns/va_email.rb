module VaEmail
  extend ActiveSupport::Concern

  class_methods do
    def valid_va_email
      /\A([^@\s]+)@(va.gov)\z/i
    end
  end
end