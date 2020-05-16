class PageComponent < ApplicationRecord
  belongs_to :page, optional: true
  acts_as_list scope: :page
  belongs_to :component, polymorphic: true, autosave: true
  accepts_nested_attributes_for :component

  after_destroy :destroy_component

  def destroy_component
    _component = eval("#{self.component_type}.find(#{self.component_id})")
    _component.destroy if _component
  end

  COMPONENT_TYPES = %w(PageHeaderComponent PageParagraphComponent)

  # used for the component selection on the page builder
  # 'ClassName': 'Friendly Name'
  COMPONENT_SELECTION = {
      'PageHeaderComponent': 'Header',
      'PageParagraphComponent': 'Paragraph'
  }

  def build_component(params)
    # TODO: swap out COMPONENT_TYPES
    raise "Unknown component_type: #{component_type}" unless COMPONENT_TYPES.include?(component_type)
    if component_id
      _component = eval("#{self.component_type}.find(#{self.component_id})")
      _component.update(params)
    else
      _component = component_type.constantize.new(params)
    end
    debugger
    self.component = _component
  end
  
end
