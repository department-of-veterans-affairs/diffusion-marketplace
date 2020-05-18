class PageGroupConstraint
  def self.matches?(request)
    path_parts = request.path.split('/')
    PageGroup.friendly.find(path_parts[1]).present? && Page.find_by(slug: path_parts[2]).present? rescue false
  end
end
