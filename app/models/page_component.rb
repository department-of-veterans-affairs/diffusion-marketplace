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

  # used for the component selection on the page builder
  # 'Friendly Name': 'ClassName'
  COMPONENT_SELECTION = {
      'Header': 'PageHeaderComponent',
      'Heading 2': 'PageHeader2Component',
      'Body text': 'PageParagraphComponent',
      'Practices': 'PagePracticeListComponent',
      'Subpage Hyperlink': 'PageSubpageHyperlinkComponent'
  }

  def build_component(params)
    raise "Unknown component_type: #{component_type}" unless COMPONENT_SELECTION.values.include?(component_type)
    if component_id
      _component = eval("#{self.component_type}.find(#{self.component_id})")
      _component.update(params)
    else
      _component = component_type.constantize.new(params)
    end
    self.component = _component
  end

end
