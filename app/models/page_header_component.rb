class PageHeaderComponent < ApplicationRecord
  belongs_to :page_component, optional: true
end
