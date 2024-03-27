class AddHideOncePassedToPageEventComponents < ActiveRecord::Migration[6.1]
  def change
    add_column :page_event_components, :hide_once_passed, :boolean, default: false
  end
end
