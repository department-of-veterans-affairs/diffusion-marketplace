class PageGroup < ApplicationRecord
  COMMUNITIES = [
    "VA Immersive",
		"Suicide Prevention",
		"Age-Friendly"
  ]
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :pages, dependent: :destroy
  has_many :editor_roles, -> { where(name: 'page_group_editor', resource_type: 'PageGroup') },
            class_name: 'Role', foreign_key: :resource_id, inverse_of: :page_group
  has_many :editors, through: :editor_roles, source: :users

  before_destroy :remove_editor_roles

  validates_uniqueness_of :name
  validates :name, presence: true
  validates :description, presence: true
  resourcify

  scope :community, -> { where(name: COMMUNITIES) }

  scope :accessible_by, -> (user) do
    if user.has_role?(:admin)
      all
    else
      where(id: user.editable_page_group_ids)  # Non-admins get access to their editable page groups
    end
  end

  def self.community_with_home_hash(public = true, admin = false)
    query = PageGroup.community.joins(:pages).where(pages: { slug: 'home' })
    query = query.where(pages: { is_public: true }) if public

    query = query.where.not(pages: { published: nil }) unless admin

    hash = {}
    if query
      query.find_each do |page_group|
        key = page_group.name
        key += " - Admin Preview" if admin && !page_group.pages.where(slug: 'home').first.published?

        hash[key] = page_group.slug
      end
    end

    hash
  end

  def is_community?
    COMMUNITIES.include?(self.name)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "slug", "updated_at", "pages_id", "editor_roles_id_eq", "roles_id_eq"]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[pages editors]
  end

  def editors_emails_string
    editors.order(:email).pluck(:email).join(', ')
  end

  private

  def remove_editor_roles
    editor_roles.destroy_all
  end
end
