class PageOneToOneImageComponent < ApplicationRecord
  include TextAndImageComponent
      FORM_FIELDS = { # Fields and labels in .arb form
        title: 'Title',
        url: 'URL',
        url_link_text: 'URL link text',
        text: 'Text',
        text_alignment: 'Text',
        image: 'Image',
        image_file_name: 'Image file name',
        image_alt_text: 'Alternative Text'
      }.freeze
end