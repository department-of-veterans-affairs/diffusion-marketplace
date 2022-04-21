class Cache
  def delete_cache_key(key)
    Rails.cache.delete(key)
  end
end