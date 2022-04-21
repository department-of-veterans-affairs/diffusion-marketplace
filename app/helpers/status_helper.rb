module StatusHelper
  def get_current_revision_file
    File.new("REVISION") rescue nil
  end

  def revision
    get_current_revision_file.read rescue nil
  end

  def cached_revision
    Rails.cache.fetch('revision') do
      revision
    end
  end

  def reset_revision_cache
    Cache.new.delete_cache_key('revision')
    cached_revision
  end
end