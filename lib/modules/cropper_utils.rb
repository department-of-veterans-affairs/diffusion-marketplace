module CropperUtils
  def is_cropping?(params)
    return params[:crop_x].present? && params[:crop_y].present? && params[:crop_w].present? && params[:crop_h].present?
  end

  def reprocess_avatar(record, params)
    record.crop_x = params[:crop_x]
    record.crop_y = params[:crop_y]
    record.crop_w = params[:crop_w]
    record.crop_h = params[:crop_h]
    record.avatar.reprocess!
  end

  def reprocess_attachment(record, params)
    record.crop_x = params[:crop_x]
    record.crop_y = params[:crop_y]
    record.crop_w = params[:crop_w]
    record.crop_h = params[:crop_h]
    record.attachment.reprocess!
  end
end
