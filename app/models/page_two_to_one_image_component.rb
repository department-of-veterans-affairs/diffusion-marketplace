class PageTwoToOneImageComponent < ApplicationRecord
  include TextAndImageComponent
    FORM_FIELDS = { # Fields and labels in .arb form
      title: 'Title',
      url: 'URL',
      url_link_text: 'URL link text',
      text_alignment: 'Text',
      image_file_name: 'Text alignment',
      image_alt_text: 'Alternative Text',
      flipper_ratio: 'Flip Image To Text Ratio'
    }.freeze
end