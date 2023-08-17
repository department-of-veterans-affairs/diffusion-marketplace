class PageComponent < ApplicationRecord
  belongs_to :page, optional: true
  acts_as_list scope: :page
  belongs_to :component, polymorphic: true, autosave: true

  accepts_nested_attributes_for :component

  after_destroy :destroy_component

  # used after destroying the page component
  def destroy_component
    _component = eval("#{self.component_type}.find('#{self.component_id}')")
    _component.destroy if _component
  end

  # used for the component selection on the page builder
  # 'Friendly Name': 'ClassName'
  COMPONENT_SELECTION = {
      'Heading 2': 'PageHeader2Component',
      'Heading 3': 'PageHeader3Component',
      'Body text': 'PageParagraphComponent',
      'Three Text Columns': 'PageTripleParagraphComponent',
      'Block Quote': 'PageBlockQuoteComponent',
      'Subpage Hyperlink': 'PageSubpageHyperlinkComponent',
      'Text and Images': 'PageCompoundBodyComponent',
      '1:1 Image to Text': 'PageOneToOneImageComponent',
      '2:1 Image to Text': 'PageTwoToOneImageComponent',
      'Accordion': 'PageAccordionComponent',
      'Simple Button': 'PageSimpleButtonComponent',
      'Image': 'PageImageComponent',
      'Call to Action': 'PageCtaComponent',
      'Downloadable File': 'PageDownloadableFileComponent',
      'Horizontal Separator line ': 'PageHrComponent',
      'Event': 'PageEventComponent',
      'News': 'PageNewsComponent',
      'Innovations': 'PagePracticeListComponent',
      'Publication': 'PagePublicationComponent',
      'YouTube Player': 'PageYouTubePlayerComponent',
      'Google Map': 'PageMapComponent'
  }

  def build_component(params)
    raise "Unknown component_type: #{component_type}" unless COMPONENT_SELECTION.values.include?(component_type)
    if component_id
      _component = eval("#{self.component_type}.where({id: '#{self.component_id}'}).first")
      if _component
        # update the current one
        _component.update(params)
      else
        # Delete the component associated with this page component and make a new one.
        # There should only be one component associated with the page component
        COMPONENT_SELECTION.values.each do |c|
          delete_component =  c.constantize.where({page_component: self}).first
          delete_component.destroy if delete_component
        end
        _component = component_type.constantize.new(params)
      end
    else
      # make a brand new component
      _component = component_type.constantize.new(params)
    end
    self.component = _component
  end

end
