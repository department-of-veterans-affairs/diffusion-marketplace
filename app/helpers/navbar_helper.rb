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
    PageGroup::COMMUNITIES.each_with_object({}) do |community, communities_hash|
      page_group = query.find_by(name: community)
      if page_group.present?
        community += " - Preview" if !page_group.pages.first&.published?
        communities_hash[community] = page_group.slug
      end
    end
  end
end
