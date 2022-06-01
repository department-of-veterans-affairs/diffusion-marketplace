module PracticeResourcesHelper
  def resource_image_default_alt_text(resource_record)
    resource_class_name = resource_record.class.to_s.split(/(?=[A-Z])/).second
    revised_resource_class_name = resource_class_name === 'Multimedium' ? 'Multimedia' : resource_class_name
    "#{revised_resource_class_name} image #{resource_record.position}"
  end
end