module NavbarHelper
  extend ActiveSupport::Concern

  def communities_with_home_hash
    # Determine the cache key based on whether there is a logged-in user or not
    user_id = current_user ? current_user.id : 'guest'
    cache_key = [user_id, 'communities_for_header']

    # Fetch or store the result in the cache
    Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      query = PageGroup.community.joins(:pages).where(pages: { slug: 'home' })

      if current_user.present?
        query = handle_user_specific_communities_query(query)
      else
        query = query.where(pages: { is_public: true }).where.not(pages: { published: nil })
      end

      assemble_page_group_hash(query)
    end
  end

  private

  def handle_user_specific_communities_query(query)
    if is_editor? && !is_admin?
      editor_page_group_ids = current_user.editable_page_group_ids
      query.where.not(pages: { published: nil }).or(query.where(id: editor_page_group_ids))
    elsif !is_admin?
      query.where.not(pages: { published: nil })
    else
      query
    end
  end

  def assemble_page_group_hash(query)
    communities = query.sort_by { |page_group| PageGroup::COMMUNITIES.index(page_group.name) }

    communities.each_with_object({}) do |community, communities_hash|
      key = community.name
      key += " - Preview" if !community.pages.first&.published?
      communities_hash[key] = community.slug
    end
  end
end
