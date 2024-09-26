module InnovationControllerMethods
  extend ActiveSupport::Concern

  def permitted_dynamic_keys(params)
    return {} unless params

    params.transform_keys! do |key|
      key.match?(/^\d+$/) ? "#{key}_resource" : key
    end

    params.keys.index_with do |_key|
      [
        :id,
        :link_url,
        :attachment_file_name,
        :description,
        :position,
        :resource,
        :resource_type_label,
        :resource_type,
        :media_type,
        :crop_x,
        :crop_y,
        :crop_w,
        :crop_h,
        :name,
        :image_alt_text,
        :attachment,
        :_destroy,
        :value
      ]
    end
  end
end