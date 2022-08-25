class PageMapComponent < ApplicationRecord
  has_one :page_component, as: :component, autosave: true
  # DB schema for Map Component...
  #   Table: page_map_components
  #   title string
  #   description: string
  #   practices: string array[]
  #   adoption_status: string SUP - if empty all adoptions display with no status.
  #     If any specified S, U or P - only the specified adoptions display on the map and their status is displayed as well.
end