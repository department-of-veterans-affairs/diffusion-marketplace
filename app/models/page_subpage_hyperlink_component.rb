class PageSubpageHyperlinkComponent < ApplicationRecord
    has_one :page_component, as: :component, autosave: true

    FORM_FIELDS = {
        url: 'Subpage URL suffix',
        title: 'Subpage title',
        description: 'Subpage description',
        card: 'Add card styling'
    }.freeze

    validates_with InternalUrlValidator
end
