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

  def landing_page
    Page.find_by(page_group_id: self.id, slug: 'home')
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
    ["created_at", "description", "id", "name", "slug", "updated_at", "pages_id"]
  end
end
