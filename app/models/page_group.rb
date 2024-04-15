class PageGroup < ApplicationRecord
  COMMUNITIES = [
    "VA Immersive",
		"Suicide Prevention",
		"Age-Friendly"
  ]
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :pages, dependent: :destroy
  has_many :editor_roles, -> { where(name: 'page_group_editor', resource_type: 'PageGroup') }, class_name: 'Role', foreign_key: :resource_id
  has_many :editors, through: :editor_roles, source: :users

  before_destroy :remove_all_editor_roles

  validates_uniqueness_of :name
  validates :name, presence: true
  validates :description, presence: true
  resourcify

  scope :community, -> { where(name: COMMUNITIES) }

  attr_accessor :new_editors, :remove_editors

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

  def remove_editor_roles(editor_ids)
    editors.where(id: editor_ids).find_each do |editor|
      editor.remove_role(:page_group_editor, self)
    end
  end

  def add_editor_roles_by_emails(editor_emails)
    emails = editor_emails.to_s.split(',').map(&:strip).uniq
    users = User.where(email: emails)
    existing_emails = users.pluck(:email)
    non_existent_emails = emails - existing_emails

    if non_existent_emails.empty?
      users.each { |user| user.add_role(:page_group_editor, self) }
      [nil, true]
    else
      [non_existent_emails, false]
    end
  end

  private

  def remove_all_editor_roles
    editor_roles.destroy_all
  end
end
