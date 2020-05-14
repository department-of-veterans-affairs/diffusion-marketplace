class PageComponent < ApplicationRecord
  belongs_to :page
  acts_as_list scope: :page
  belongs_to :component, polymorphic: true
  accepts_nested_attributes_for :component

  COMPONENT_TYPES = %w(PageHeaderComponent PageParagraphComponent)

  def build_component(params)
    raise "Unknown component_type: #{component_type}" unless COMPONENT_TYPES.include?(component_type)
    self.component = component_type.constantize.new(params)
  end

end
