class PracticeResource < ApplicationRecord
  acts_as_list scope: :practice
  after_create :attachment_crop
  before_save :clear_searchable_practices_cache_on_save
  before_destroy :clear_searchable_practices_cache_on_destroy
   after_save :reset_searchable_practices_cache
  after_destroy :reset_searchable_practices_cache

  attr_accessor :reset_cached_searchable_practices

  has_attached_file :attachment, styles: {thumb: '768x432>'}, :processors => [:cropper]
  before_post_process :skip_for_non_image

  do_not_validate_attachment_file_type :attachment
  belongs_to :practice

  enum resource_type: {core: 0, optional: 1, support: 2}
  enum media_type: {resource: 0, file: 1, link: 2}
  enum resource_type_label: {people: 0, processes: 1, tools: 2}

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def attachment_s3_presigned_url(style = nil)
    object_presigned_url(attachment, style)
  end

  def clear_searchable_practices_cache
    cache_keys = ["searchable_practices_json", "searchable_public_practices_json"]
    cache_keys.each do |cache_key|
      Rails.cache.delete(cache_key)
    end
  end

  def clear_searchable_practices_cache_on_save
    if self.changed?
      self.reset_cached_searchable_practices = true
    end
  end

  def clear_searchable_practices_cache_on_destroy
    self.reset_cached_searchable_practices = true
  end

  def reset_searchable_practices_cache
    clear_searchable_practices_cache if self.reset_cached_searchable_practices
  end

  private

  def skip_for_non_image
    %w(image/jpg image/jpeg image/png).include?(attachment_content_type)
  end

  def attachment_crop
    process_attachment_crop({crop_w: @crop_w, crop_h: @crop_h, crop_x: @crop_x, crop_y: @crop_y})
  end
end