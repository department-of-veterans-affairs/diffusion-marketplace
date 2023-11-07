class AddDateToPageEventComponent < ActiveRecord::Migration[6.0]
  def change
    add_column :page_event_components, :start_date, :date
    add_column :page_event_components, :end_date, :date
  end
end
