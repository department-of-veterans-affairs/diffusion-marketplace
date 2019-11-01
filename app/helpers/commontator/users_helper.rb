module Commontator::UsersHelper
    def show_user_avatar(user)
        if user.avatar.exists?
            image_tag(user.avatar_s3_presigned_url, alt: "Profile Avatar") # Add in classes later if needed
        else
            content_tag(:span, '', class: "fas fa-user-circle").html_safe
        end
    end
end

Commontator::SharedHelper.class_eval do
    extend Commontator::UsersHelper
end