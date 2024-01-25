class PageGroup < ApplicationRecord
  COMMUNITIES = [
    "VA Immersive",
		"Suicide Prevention",
		"Age-Friendly"
  ]
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :pages, dependent: :destroy
  validates_uniqueness_of :name
  validates :name, presence: true
  validates :description, presence: true
  resourcify

  scope :community, -> { where(name: COMMUNITIES) }

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
    ["created_at", "description", "id", "name", "slug", "updated_at", "pages_id"]
  end

  def editors
    User.with_role(:editor, self)
  end
end
