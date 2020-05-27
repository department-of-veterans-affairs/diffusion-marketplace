class PageSubpageHyperlinkComponent < ApplicationRecord
    has_one :page_component, as: :component, autosave: true
    validates_with InternalUrlValidator
end
