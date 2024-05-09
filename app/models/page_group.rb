class PageGroup < ApplicationRecord
  COMMUNITIES = [
    "VA Immersive",
		"Age-Friendly",
		"Suicide Prevention"
  ]
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :pages, dependent: :destroy
  has_many :editor_roles, -> { where(name: 'page_group_editor', resource_type: 'PageGroup') },
            class_name: 'Role', foreign_key: :resource_id, inverse_of: :page_group
  has_many :editors, through: :editor_roles, source: :users

  before_destroy :remove_all_editor_roles

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

  attr_accessor :new_editors, :remove_editors

  def is_community?
    COMMUNITIES.include?(self.name)
  end

  def landing_page
    pages.find_by(slug: 'home')
  end

  def subnav_hash
    return nil if self.pages.empty?
    if self.landing_page&.published? # Use all pages when community homepage has not been published
      subpages = self.pages.filter { |page| page.published? }.pluck("slug")
    else # Only show published subnav pages when homepage has been published
      subpages = self.pages.pluck("slug")
    end
    # TODO: replace hash with PageBuilder UI supplied info
    approved_subpages =  { # Use hardcoded titles for nav because of mismatch with actual page names
      "Community": "home",
      "About": "about",
      "Innovations": "innovations",
      "Events and News": "events-and-news",
      "Getting Started": "getting-started",
      "Publications": "publications"
    }

    approved_subpages.filter {|k,v| subpages.include?(v)}
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

  private

  def remove_all_editor_roles
    editor_roles.destroy_all
  end
end
