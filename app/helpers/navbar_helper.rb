module NavbarHelper
  extend ActiveSupport::Concern

  def communities_with_home_hash(user=nil)
    query = PageGroup.community.joins(:pages).where(pages: { slug: 'home' })

    if user.present?
      query = handle_user_specific_communities_query(query, user)
    else
      query = query.where(pages: { is_public: true }).where.not(pages: { published: nil })
    end

    assemble_page_group_hash(query)
  end

  private

  def handle_user_specific_communities_query(query, user)
    is_editor = user.has_role?(:page_group_editor, :any)
    is_admin = user.has_role?(:admin)

    if is_editor && !is_admin
      editor_page_group_ids = user.editable_page_group_ids
      query.where.not(pages: { published: nil }).or(query.where(id: editor_page_group_ids))
    elsif !is_admin
      query.where.not(pages: { published: nil })
    else
      query
    end
  end

  def assemble_page_group_hash(query)
    communities = query.sort_by{|page_group| PageGroup::COMMUNITIES.index(page_group.name)}

    communities.each_with_object({}) do |community, communities_hash|
      key = community.name
      key += " - Preview" if !community.pages.first&.published?
      communities_hash[key] = community.slug
    end
  end
end
