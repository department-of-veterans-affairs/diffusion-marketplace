class AddHideAfterDateToPageEventComponents < ActiveRecord::Migration[6.1]
  def change
    add_column :page_event_components, :hide_after_date, :boolean, default: false
  end
end
