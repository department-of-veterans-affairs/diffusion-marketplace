class PageTwoToOneImageComponent < ApplicationRecord
  include TextAndImageComponent
  FORM_FIELDS = { # Fields and labels in .arb form
    title: 'Title',
    url: 'URL',
    url_link_text: 'URL link text',
    text: 'Text',
    text_alignment: 'Text alignment',
    image: 'Image',
    image_file_name: 'Image filename',
    image_alt_text: 'Alternative Text',
    flipped_ratio: 'Flip Image To Text Ratio'
  }.freeze
end